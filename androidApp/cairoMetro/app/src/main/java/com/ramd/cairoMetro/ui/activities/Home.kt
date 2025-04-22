package com.ramd.cairoMetro.ui.activities

import android.R.layout
import android.content.Intent
import android.content.SharedPreferences
import android.location.Location
import android.os.Bundle
import android.view.View
import android.widget.Toast
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import androidx.core.view.isVisible
import com.ramd.cairoMetro.R
import com.ramd.cairoMetro.databinding.ActivityHomeBinding
import com.ramd.cairoMetro.data.DataHandling
import com.ramd.cairoMetro.data.DataItem
import com.ramd.cairoMetro.businessLogic.LocationCalculations
import mumayank.com.airlocationlibrary.AirLocation
import java.util.Locale
import android.content.res.Configuration
import android.util.Log
import com.ramd.cairoMetro.coreApp.Application
import androidx.core.content.edit
import androidx.lifecycle.lifecycleScope
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.ramd.cairoMetro.ui.customViews.CustomArrayAdapter
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

class Home : AppCompatActivity(),AirLocation.Callback {
    lateinit var binding: ActivityHomeBinding
    lateinit var readAndWriteData: DataHandling
    var stationData: Array<DataItem> = emptyArray()
    var stationNames = emptyList<String>()
    val location = LocationCalculations()
    lateinit var airLocation:AirLocation
    lateinit var home: SharedPreferences
    var currentLocation = mutableListOf<Double>()
    var path= emptyList<String>()
    var currentStation ="" ; var indicator = false
    var language="" ; var previousStation=""


    override fun onCreate(savedInstanceState: Bundle?) {
        val application = application as Application
        setupApplication(application)
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        binding= ActivityHomeBinding.inflate(layoutInflater)
        setContentView(binding.root)
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main2)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }

        homeDataLoadLanguageChange()

        startAndEndAdapter()

        getPreviousStation(application)

        startLocation()


    }

    private fun startLocation() {
        airLocation = AirLocation(this, this, false, 5000)
        airLocation.start()
    }


    private fun getPreviousStation(application: Application) {
        val getID = application.previousStationID
        if (getID != 0 && indicator) {
            previousStation = stationData.firstOrNull { it.id == getID }?.name ?: ""
        }
    }


    private fun startAndEndAdapter() {
        stationNames = stationData.map { it.name }.toSet().toList()
        val adapter = CustomArrayAdapter(this, layout.simple_dropdown_item_1line, stationNames)
        binding.start.setAdapter(adapter)
        val adapter2 = CustomArrayAdapter(this, layout.simple_dropdown_item_1line, stationNames)
        binding.arrival.setAdapter(adapter2)
    }


    private fun setupApplication(application: Application) {
        stationData = application.stationData
        readAndWriteData = application.readAndWriteData

        val pathChanged = readAndWriteData.getPathData(this, stationData)

        if (readAndWriteData.getSimpleData(this,"languageChange") && pathChanged.isNotEmpty()) {
            readAndWriteData.saveListData(this, pathChanged.toTypedArray(), "path")
            readAndWriteData.saveSimpleData(this,false,"languageChange")
        }
        indicator = application.indicator
        language = application.language
        loadLocale()
        path = application.path.toList()
    }


    fun changeLanguage(view: View) {

        if ( ! readAndWriteData.getSimpleData(this,"indicator")) {
            readAndWriteData.homeDataSave(this,stationData,
                shortRoute = binding.lessTransfer.isChecked,
                arrival = binding.arrival.text.toString(),
                start = binding.start.text.toString(),
            )
            showLanguageDialog()
        }
        else
        {
            readAndWriteData.extractPathId(this,path,stationData)
            showLanguageDialog()
            readAndWriteData.saveSimpleData(this,true,"languageChange")
        }
    }

    private fun showLanguageDialog() {
        val languages = arrayOf("\uD83C\uDDFA\uD83C\uDDF8 English", "\uD83C\uDDEA\uD83C\uDDEC   العربية")
        val languageCodes = arrayOf("en", "ar")

        val builder = MaterialAlertDialogBuilder(this, R.style.CustomAlertDialogTheme)
        builder.setTitle(getString(R.string.choose_language))

        builder.setItems(languages) { _, which ->
            val selectedLanguage = languageCodes[which]
            if(selectedLanguage != language) {
                switchLanguage(selectedLanguage)
            }
        }

        builder.show()
    }

    private fun switchLanguage(lang: String) {
        val prefs: SharedPreferences = getSharedPreferences("savedData", MODE_PRIVATE)
        prefs.edit() {
            putString("My_Lang", lang)
        }

        setLocale(lang)
    }

    private fun setLocale(lang: String) {
        val locale = Locale(lang)
        Locale.setDefault(locale)
        val config = Configuration()
        config.setLocale(locale)
        resources.updateConfiguration(config, resources.displayMetrics)
        baseContext.resources.updateConfiguration(config, baseContext.resources.displayMetrics)
        val intent = Intent(this, Home::class.java)
        startActivity(intent)
        finish()
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

    override fun onBackPressed() {
        stationNames = emptyList()
        val editor = home.edit()
        editor.clear()
        editor.apply()
        stationData = emptyArray()
        path =emptyList()
        currentLocation.clear()
        finishAffinity()
        super.onBackPressed()
    }


    override fun onDestroy() {
        val editor = home.edit()
        editor.clear()
        editor.apply()
        super.onDestroy()
    }

    fun exchangeStations(view: View) {
        val arrivalStation = binding.arrival.text.toString()
        val startStation =binding.start.text.toString()
        binding.start.setText(arrivalStation,false)
        binding.arrival.setText(startStation,false)

    }

    fun start(view: View) {
        if(!validateStations())return
        val start = binding.start.text.toString()
        val arrival = binding.arrival.text.toString()

        val shortRoute =binding.lessTransfer.isChecked

        var station =""
        if(currentLocation.isNotEmpty()) {
            station =
                location.nearestLocation(stationData, 0.2F, currentLocation[0], currentLocation[1])
        }
        val a = Intent(this, AllRoutes::class.java)
        a.putExtra("startStation",start)
        a.putExtra("arrivalStation",arrival)
        a.putExtra("shortType",shortRoute)
        a.putExtra("tripAvailability",station.isNotEmpty() )
        startActivity(a)
    }

    fun showNearest(view: View) {

        if(currentLocation.isNotEmpty()) {
            val station =
                location.nearestLocation(stationData, 100F, currentLocation[0], currentLocation[1])
            if (station.isEmpty())
                showToast(getString(R.string.no_near_station_from_your_location))
            else binding.start.setText(station, false)
        }

    }

    fun map(view: View) {
        val station = binding.start.text.toString()
        if(station.isNotEmpty()) {
            val stationCoordinates = stationData.first { it.name == station}.coordinates
            location.directionFromCurrentMap(stationCoordinates[0].toString(),stationCoordinates[1].toString(),this)
        }
        else
        {
            showToast(getString(R.string.enter_station_in_start_station))
        }
    }

    fun search(view: View) {
        val address = binding.address.text.toString()
        if (address == "")
        {
            showToast(getString(R.string.please_input_an_address))
        }
        else {
            val startDetails = location.getLatAndLong(this, address)
            if (startDetails == Pair(0.0, 0.0))
                showToast(getString(R.string.the_address_is_not_valid))
            else if (startDetails == Pair(-1.0, -1.0))
                showToast(getString(R.string.error_while_loading_the_data_try_again))
            else {
                val station = location.nearestLocation(
                    stationData,
                    50F,
                    startDetails.first,
                    startDetails.second
                )

                if (station.isEmpty())
                    showToast(getString(R.string.no_near_station_to_your_destination))
                else binding.arrival.setText(station, false)
            }
        }
    }

    fun viewAll(view: View) {
        val a = Intent(this , TripProgress::class.java)
        a.putExtra("currentStation",currentStation)
        a.putExtra("homePath",path as ArrayList<String>)
        startActivity(a)
    }

    private fun validateStations(): Boolean {
        return when {
            binding.start.text.isNullOrEmpty() || binding.arrival.text.isNullOrEmpty() -> {
                showToast(getString(R.string.select_a_station))
                false
            }
            binding.start.text.toString() == binding.arrival.text.toString() -> {
                showToast(getString(R.string.arrival_and_start_station_can_t_be_the_same))
                false
            }
            binding.start.text.toString() !in stationNames || binding.arrival.text.toString() !in stationNames-> {
                showToast(getString(R.string.wrong_station_name))
                false
            }
            else -> true
        }
    }


    private fun showToast(message: String) {
        Toast.makeText(this, message, Toast.LENGTH_SHORT).show()
    }


    private fun stationDialog () {

        if(  indicator && path.isNotEmpty() ) {

            currentStation = location.nearestStationPath(stationData,300F,path,currentLocation[0],currentLocation[1])

            if (currentStation.isNotEmpty()) {
                binding.status.isVisible = true

                if(previousStation =="" )
                { previousStation =currentStation}

                if (path.indexOf(previousStation) <= path.indexOf(currentStation)) {
                    previousStation = currentStation
                    Log.d("LocationServiceTRIP", "${indicator} , PREVIOUS STATION in home inside$previousStation")

                    uiForLocationUpdate()

                    if (previousStation == path.last()) {
                        indicator = false
                        readAndWriteData.saveSimpleData(this, false, "indicator")
                        binding.status.visibility = View.GONE;
                        readAndWriteData.saveID(this, 0,"previousHome")

                    }
                }
            }
            else
            {
                if(previousStation == ""){
                    previousStation = path[0]}
                binding.status.isVisible = true
                uiForLocationUpdate()
            }
        }
        val id = stationData.firstOrNull{it.name== previousStation }?.id
        if(id != null) {
            readAndWriteData.saveID(this, id,"previousHome")
        }

    }

    private fun uiForLocationUpdate() {
        binding.currentStation.text = previousStation
        val stationIndex = path.indexOf(previousStation)
        if (stationIndex < path.size - 1) {
            binding.nextStation.text = path[stationIndex + 1]
        } else {
            binding.nextStation.text = ""
        }
        if (stationIndex > 0) {
            binding.perviousStation.text = path[stationIndex - 1]
        } else {
            binding.perviousStation.text = ""
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        airLocation.onActivityResult(requestCode, resultCode, data)
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        airLocation.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }

    override fun onSuccess(locations: ArrayList<Location>) {
        currentLocation.clear()
        currentLocation.add(locations[0].latitude)
        currentLocation.add(locations[0].longitude)
        stationDialog ()

    }

    override fun onFailure(locationFailedEnum: AirLocation.LocationFailedEnum) {
        if (locationFailedEnum == AirLocation.LocationFailedEnum.HIGH_PRECISION_LOCATION_NA_TRY_AGAIN_PREFERABLY_WITH_NETWORK_CONNECTIVITY)
             {
                lifecycleScope.launch {
                    delay(10000)
                    if (currentLocation.isEmpty() ) {
                        showToast(getString(R.string.make_sure_you_are_connect_to_internet))
                    }
                }
                startLocation()
            }

    }


    private fun homeDataLoadLanguageChange(){

        home =getSharedPreferences("homeData", MODE_PRIVATE)
        binding.lessTransfer.isChecked = home.getBoolean("shortRoute", false)
        val start = stationData.firstOrNull { it.id ==  home.getInt("startID",0)}?.name
        if (start != null)
        {binding.start.setText(start,false)}
        val arrival = stationData.firstOrNull { it.id ==  home.getInt("arrivalID",0)}?.name
        if (arrival != null)
        { binding.arrival.setText(arrival,false)}

    }




}