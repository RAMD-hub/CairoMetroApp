package com.ramd.cairoMetro.services

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.res.Configuration
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.graphics.Color
import android.location.Location
import android.location.LocationManager
import android.media.RingtoneManager
import android.os.Build
import android.os.IBinder
import android.os.Looper
import android.util.Log
import android.widget.Toast
import androidx.core.app.NotificationCompat
import com.google.android.gms.location.*
import com.ramd.cairoMetro.R
import com.ramd.cairoMetro.coreApp.Application
import com.ramd.cairoMetro.data.DataHandling
import com.ramd.cairoMetro.data.DataItem
import com.ramd.cairoMetro.businessLogic.Direction
import com.ramd.cairoMetro.businessLogic.LocationCalculations
import com.ramd.cairoMetro.ui.activities.TripProgress
import java.lang.ref.WeakReference
import java.util.Locale

class LocationService : Service() {
    private val TAG = "LocationService"
    private val NOTIFICATION_ID = 1001
    private val CHANNEL_ID = "location_service_channel"
    private val PUSH_CHANNEL_ID = "push_notification_channel"
    private val UPDATE_INTERVAL = 10000L // 10 seconds
    private val FASTEST_INTERVAL = 5000L // 5 seconds
    private val SMALLEST_DISPLACEMENT = 10f // 10 meters
    private var lastGpsLogTime = 0L
    private val GPS_LOG_INTERVAL = 60000L // Only log GPS issues once per minute

    companion object {
        private var locationUpdateListener: WeakReference<LocationUpdateListener>? = null

        fun setLocationUpdateListener(listener: LocationUpdateListener?) {
            locationUpdateListener = listener?.let { WeakReference(it) }
        }
    }

    private lateinit var notificationManager: NotificationManager
    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private lateinit var locationCallback: LocationCallback
    private lateinit var locationRequest: LocationRequest
    private var lastLocation: Location? = null
    private var path = emptyList<String>()
    private var nearestStation = ""
    private var previousStation = ""
    private var stationData = emptyArray<DataItem>()
    var language = ""
    var currentLanguage = ""
    private var locationManager: LocationManager? = null
    private var isRequestingLocationUpdates = false
    private var startTrip = false

    interface LocationUpdateListener {
        fun onLocationChanged(location: Location)
    }

    override fun onCreate() {
        super.onCreate()

        val application = application as Application
        val readAndWriteData = application.readAndWriteData

        locationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager
        notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        createNotificationChannels()

        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
        createLocationRequest()

        locationCallback = object : LocationCallback() {
            override fun onLocationResult(locationResult: LocationResult) {
                locationResult.lastLocation?.let { location ->
                    lastLocation = location
                    getStationAndNotification(readAndWriteData, application, location)
                    locationUpdateListener?.get()?.onLocationChanged(location)
                }
            }

            override fun onLocationAvailability(locationAvailability: LocationAvailability) {
                if (!locationAvailability.isLocationAvailable) {
                    // Log GPS issues with rate limiting to avoid log spam
                    val currentTime = System.currentTimeMillis()
                    if (currentTime - lastGpsLogTime > GPS_LOG_INTERVAL) {
                        Log.e(TAG, "Location is not available. GPS may be disabled or signal is weak.")
                        Toast.makeText(this@LocationService,
                            getString(R.string.location_is_not_available_gps_may_be_disabled_or_signal_is_weak), Toast.LENGTH_SHORT).show()

                        if (!isLocationEnabled()) {
                            Log.e(TAG, "GPS and Network providers are disabled in system settings.")
                            Toast.makeText(this@LocationService,
                                getString(R.string.gps_and_network_providers_are_disabled_in_system_settings), Toast.LENGTH_SHORT).show()

                        }
                        lastGpsLogTime = currentTime
                    }

                    // Try to restart location updates if possible
                    if (isLocationEnabled() && !isRequestingLocationUpdates) {
                        Log.d(TAG, "Location providers available but not getting updates. Attempting to restart.")
                        startLocationUpdates()
                    }
                }
            }
        }
    }

    private fun isLocationEnabled(): Boolean {
        return locationManager?.isProviderEnabled(LocationManager.GPS_PROVIDER) == true ||
                locationManager?.isProviderEnabled(LocationManager.NETWORK_PROVIDER) == true
    }

    private fun getStationAndNotification(
        readAndWriteData: DataHandling,
        application: Application,
        location: Location
    ) {
        stationData = application.stationData
        path = application.path.toList()
        language = application.language
        if (language != currentLanguage) {
            loadLocale()
            notificationManager.notify(NOTIFICATION_ID, createNotification())
        }

        nearestStation = LocationCalculations().nearestStationPath(
            stationData,
            1000F,
            path,
            location.latitude,
            location.longitude
        )

        val getID = readAndWriteData.getID(this@LocationService, "previousService")
        if (getID != 0 && startTrip) {
            previousStation = stationData.firstOrNull { it.id == getID }?.name ?: ""
        }

        if (nearestStation.isNotEmpty() && previousStation!= nearestStation) {

            if (previousStation == "") {
                startTrip =true
                previousStation = nearestStation
            }

            if (previousStation in path && path.indexOf(previousStation) <= path.indexOf(
                    nearestStation
                )
            ) {
                notifyUsingDistance(nearestStation)
                previousStation = nearestStation

                val id = stationData.firstOrNull { it.name == previousStation }?.id
                if (id != null) {
                    readAndWriteData.saveID(this@LocationService, id, "previousService")

                    if (nearestStation == path[path.size - 1]) {
                        readAndWriteData.saveID(this@LocationService, 0, "previousService")
                        stopSelf()
                    }
                }


            }

//            Log.d(TAG, "From service current: $nearestStation")
        }
    }

    private fun loadLocale() {
        currentLanguage = language
        val locale = Locale(language)
        Locale.setDefault(locale)

        val config = Configuration(resources.configuration)
        config.setLocale(locale)
        config.setLayoutDirection(locale)

        resources.updateConfiguration(config, resources.displayMetrics)
        baseContext.resources.updateConfiguration(config, baseContext.resources.displayMetrics)
    }

    private fun createLocationRequest() {
        locationRequest = LocationRequest.create().apply {
            priority = LocationRequest.PRIORITY_HIGH_ACCURACY  // Changed from BALANCED_POWER_ACCURACY for better GPS precision
            interval = UPDATE_INTERVAL
            fastestInterval = FASTEST_INTERVAL
            smallestDisplacement = SMALLEST_DISPLACEMENT
            maxWaitTime = UPDATE_INTERVAL * 2 // Allow batching of updates to save battery
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        startForeground(NOTIFICATION_ID, createNotification())
        startLocationUpdates()

        return START_STICKY
    }

    private fun startLocationUpdates() {
        if (isRequestingLocationUpdates) {
            Log.d(TAG, "Location updates already requested")
            return
        }

        try {
            val builder = LocationSettingsRequest.Builder()
                .addLocationRequest(locationRequest)

            val client = LocationServices.getSettingsClient(this)
            client.checkLocationSettings(builder.build())
                .addOnSuccessListener {
                    isRequestingLocationUpdates = true
                    fusedLocationClient.requestLocationUpdates(
                        locationRequest,
                        locationCallback,
                        Looper.getMainLooper()
                    )
                    Log.d(TAG, "Location updates started successfully")
                }
                .addOnFailureListener { e ->
                    isRequestingLocationUpdates = false
                    Log.e(TAG, "Location settings are not satisfied: ${e.message}")
                    // Instead of showing notification, just log the issue
                    Log.e(TAG, "GPS or Network location is disabled. Location tracking may not work properly.")
                }
        } catch (e: SecurityException) {
            Log.e(TAG, "Lost location permission: ${e.message}")
        }
    }

    private fun stopLocationUpdates() {
        if (isRequestingLocationUpdates) {
            fusedLocationClient.removeLocationUpdates(locationCallback)
            isRequestingLocationUpdates = false
            Log.d(TAG, "Location updates stopped")
        }
    }

    private fun createNotification() =


        NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_stat_notificon)
            .setColor(Color.RED)
            .setContentTitle(getString(R.string.station_alert))
            .setContentText(getString(R.string.tracking_your_location_during_the_trip))
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setAutoCancel(false)
            .setOngoing(true)
            .setWhen(System.currentTimeMillis())
            .build()

    private fun sendPushNotification(alertTitle: String, alertMessage: String, stage: String) {
        val a = Intent(applicationContext, TripProgress::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_SINGLE_TOP
        }
        val pendingIntent = if (path.isNotEmpty() && nearestStation != path[path.size - 1]) {
            PendingIntent.getActivity(
                applicationContext,
                0,
                a,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )
        } else {
            null
        }

        val bigPicture =BitmapFactory.decodeResource(resources,
            when(stage){
                "start"->R.drawable.start
                "end"->R.drawable.end
                "change"->R.drawable.change
                else -> R.drawable.ic_stat_notificon
            }
        )
        val notification = NotificationCompat.Builder(this, PUSH_CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_stat_notificon)
            .setColor(Color.RED)
            .setContentTitle(alertTitle)
            .setContentText(alertMessage)
            .setLargeIcon(bigPicture)
            .setContentIntent(pendingIntent)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setAutoCancel(true)
            .setVibrate(longArrayOf(0, 500, 200, 500))
            .setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION))
            .build()

        notificationManager.notify(2001, notification)
    }

    private fun notifyUsingDistance(station: String) {
        val intersections = Direction(stationData).findIntersections(path)
        when (station) {
            path[0] -> sendPushNotification(
                getString(R.string.start_station),
                getString(R.string.starting_trip_soon_in_have_a_nice_trip, station),
                "start"
            )
            path[path.size - 1] -> sendPushNotification(
                getString(R.string.arrival_station),
                getString(R.string.reaching_destination_soon_in, station),
                "end"
            )
            in intersections -> sendPushNotification(
                getString(R.string.intersection_station),
                getString(R.string.reaching_an_intersection_soon_in, station),
                "change"
            )
        }
    }

    private fun createNotificationChannels() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                CHANNEL_ID,
                "Location Service Channel",
                NotificationManager.IMPORTANCE_LOW
            )

            val pushChannel = NotificationChannel(
                PUSH_CHANNEL_ID,
                "Station Alerts",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "Alerts when you arrive at important stations"
                enableLights(true)
                lightColor = Color.RED
                enableVibration(true)
            }

            notificationManager.createNotificationChannel(serviceChannel)
            notificationManager.createNotificationChannel(pushChannel)
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        super.onDestroy()
        DataHandling().saveID(this@LocationService, 0, "previousService")
        stopLocationUpdates()
        locationUpdateListener = null
    }
}