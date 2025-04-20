package com.ramd.cairoMetro.ui.activities

import android.annotation.SuppressLint
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.content.res.Configuration
import android.location.Location
import android.os.Build
import android.os.Bundle
import android.os.IBinder
import android.util.Log
import android.view.View
import android.widget.Toast
import androidx.activity.enableEdgeToEdge
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import androidx.recyclerview.widget.LinearLayoutManager
import com.ramd.cairoMetro.R
import com.ramd.cairoMetro.ui.customViews.StationItem
import com.ramd.cairoMetro.databinding.ActivityTripProgressBinding
import com.ramd.cairoMetro.coreApp.Application
import com.ramd.cairoMetro.data.DataHandling
import com.ramd.cairoMetro.data.DataItem
import com.ramd.cairoMetro.businessLogic.Direction
import com.ramd.cairoMetro.businessLogic.LocationCalculations
import com.ramd.cairoMetro.services.LocationService
import com.ramd.cairoMetro.systemIntegration.Permissions
import com.ramd.cairoMetro.businessLogic.Price
import com.xwray.groupie.GroupieAdapter
import mumayank.com.airlocationlibrary.AirLocation
import java.util.Locale

class TripProgress : AppCompatActivity() , AirLocation.Callback{

    lateinit var binding: ActivityTripProgressBinding
    lateinit var airLocation:AirLocation
    var items = mutableListOf<StationItem>()
    var adapter = GroupieAdapter()
    var path: List<String> = emptyList()
    var stationData: Array<DataItem> = emptyArray()
    lateinit var readAndWriteData: DataHandling
    var previousStation = ""; var nearestStation = ""
    var language = ""; var indicator = false


    private val permissionLauncher = registerForActivityResult(
        ActivityResultContracts.RequestMultiplePermissions()
    ) { permissions ->
        val allGranted = permissions.entries.all { it.value }

        if (allGranted) {
            startLocationService()
        } else {
            Toast.makeText(this,
                getString(R.string.location_permissions_are_required), Toast.LENGTH_LONG).show()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        val application = setUp()

        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        binding = ActivityTripProgressBinding.inflate(layoutInflater)
        setContentView(binding.root)

        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }

        getCurrentStationFromHome(application)
        getPath(application)
        setUpActivityData()
        startLocation()
    }

    @SuppressLint("StringFormatMatches")
    private fun setUpActivityData() {
        setDataInRecycler(previousStation)
        val pathCount = path.size
        val price = Price()
        binding.stationNumbers.text = getString(R.string.station_no, pathCount)
        if (pathCount * 3 / 60 >= 1) {
            binding.timeTrip.text =
                getString(R.string.time_hrs_mins, (pathCount * 3) / 60, (pathCount * 3) % 60)
        } else {
            if (pathCount * 3 % 60 in 3..10) {
                binding.timeTrip.text = getString(R.string.time_mins, (pathCount * 3) % 60)
            } else {
                binding.timeTrip.text =
                    getString(R.string.time_min, ((pathCount * 3) % 60).toString())
            }
        }
        binding.priceStation.text = getString(R.string.price, price.calculatePrice(pathCount))
    }

    private fun getCurrentStationFromHome(application: Application) {
        previousStation = intent.getStringExtra("currentStation") ?: ""

        if (previousStation.isEmpty()) {
            val getID =application.previousStationID

            if (getID != 0) {
                previousStation = stationData.firstOrNull { it.id == getID }?.name ?: ""
            }
        }
    }

    private fun getPath(application: Application) {
        var pathCheck = intent.getStringArrayListExtra("allRoutesPath")
        if (!pathCheck.isNullOrEmpty()) {
            path = pathCheck
            previousStation = path[0]
            checkPermissionsAndStartService()
            readAndWriteData.saveSimpleData(this, true, "indicator")
        } else {
            pathCheck = intent.getStringArrayListExtra("homePath")
            if (!pathCheck.isNullOrEmpty()) {
                path = pathCheck
            } else {
                if (indicator) {
                    path = application.path.toList()
                } else {
                    stopLocationService()
                    finish()
                }
            }
        }
    }

    private fun setUp(): Application {
        val application = application as Application
        stationData = application.stationData
        readAndWriteData = application.readAndWriteData
        path = application.path.toList()
        indicator = application.indicator
        language = application.language
        loadLocale()
        return application
    }

    private fun loadLocale() {
        val locale = Locale(language)
        Locale.setDefault(locale)

        val config = Configuration(resources.configuration)
        config.setLocale(locale)
        config.setLayoutDirection(locale)

        resources.updateConfiguration(config, resources.displayMetrics)
        baseContext.resources.updateConfiguration(config, baseContext.resources.displayMetrics)
    }

    override fun onDestroy() {
        items.clear()
        adapter.clear()
        stationData = emptyArray()
        super.onDestroy()
    }

    override fun onBackPressed() {
        readAndWriteData.saveListData(this, path.toTypedArray(), "path")
        val a = Intent(this, Home::class.java)
        startActivity(a)
        super.onBackPressed()
    }

    fun cancel(view: View) {
        cancelProcess()
        val a = Intent(this, Home::class.java)
        startActivity(a)
    }

    private fun setDataInRecycler(station: String) {
        val layoutManager = binding.recyclerView.layoutManager as LinearLayoutManager
        items.clear()
        val intersections = Direction(stationData).findIntersections(path)
        var line = ""
        items.addAll(path.mapIndexed { index, stationName ->
            val isCurrentStation = stationName == station
            if (index != path.size - 1) {
                line = Direction(stationData).findLine(path[index], path[index + 1])
            }
            val stationItem = when {
                index == 0 -> StationItem(stationName, start = true, stationState = isCurrentStation, context = this, line = line)
                index == path.size - 1 -> StationItem(stationName, end = true, stationState = isCurrentStation, context = this, line = line)
                stationName in intersections -> StationItem(stationName, change = true, stationState = isCurrentStation, context = this, line = line)
                else -> StationItem(stationName, stationState = isCurrentStation, context = this)
            }
            stationItem
        })

        adapter.clear()
        adapter.update(items)
        val state = items.indexOfFirst { it.stationState }
        binding.recyclerView.adapter = adapter
        layoutManager.scrollToPosition(state)
    }

    override fun onResume() {
        super.onResume()
        if (! readAndWriteData.getSimpleData(this, "indicator")) {
            val a = Intent(this, Home::class.java)
            startActivity(a)
        }
    }



    private fun checkPermissionsAndStartService() {
        if (Permissions(this).hasRequiredPermissions()) {
            startLocationService()
        } else {
            Permissions(this).requestLocationPermissions(permissionLauncher)
        }
    }

    private fun startLocationService() {
        val serviceIntent = Intent(this, LocationService::class.java)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(serviceIntent)
        } else {
            startService(serviceIntent)
        }

    }





    private fun stopLocationService() {
        val serviceIntent = Intent(this, LocationService::class.java)
        stopService(serviceIntent)
    }


    private fun cancelProcess() {
        readAndWriteData.saveSimpleData(this, false, "indicator")
        stopLocationService()
        readAndWriteData.saveID(this, 0, "previousTP")
    }

    private fun startLocation() {
        airLocation = AirLocation(this, this, false, 5000)
        airLocation.start()
    }

    override fun onFailure(locationFailedEnum: AirLocation.LocationFailedEnum) {
        when (locationFailedEnum) {
            AirLocation.LocationFailedEnum.HIGH_PRECISION_LOCATION_NA_TRY_AGAIN_PREFERABLY_WITH_NETWORK_CONNECTIVITY -> {
                startLocation()
            }
            AirLocation.LocationFailedEnum.DEVICE_IN_FLIGHT_MODE -> {
                Toast.makeText(this, getString(R.string.device_is_flight_mode), Toast.LENGTH_SHORT).show()
            }
            else -> {
                Toast.makeText(this, getString(R.string.check_location_permission), Toast.LENGTH_SHORT).show()
            }
        }
    }

    override fun onSuccess(locations: ArrayList<Location>) {
        nearestStation = LocationCalculations().nearestStationPath(stationData, 300F, path, locations[0].latitude, locations[0].longitude)
        Log.d("LocationService","${locations[0].latitude} , ${locations[0].longitude}")

        if (nearestStation.isNotEmpty() && previousStation != nearestStation) {
            if (previousStation == "") {
                previousStation = nearestStation
            }
            if (path.indexOf(previousStation) <= path.indexOf(nearestStation)) {
                runOnUiThread {
                    setDataInRecycler(nearestStation)
                }
                previousStation = nearestStation

                if (nearestStation == path[path.size - 1]) {
                    cancelProcess()
                }
            }
        }
    }
}