package com.ramd.cairoMetro.coreApp

import android.app.Application
import android.content.SharedPreferences
import android.util.Log
import com.google.gson.Gson
import com.ramd.cairoMetro.data.DataHandling
import com.ramd.cairoMetro.data.DataItem
import java.io.InputStreamReader

class Application : Application() , SharedPreferences.OnSharedPreferenceChangeListener  {


    var stationData: Array<DataItem> = emptyArray()
    val readAndWriteData = DataHandling()
    lateinit var file :SharedPreferences
    var indicator = false
    var path = emptyArray<String>()
    var language = ""
    var previousStationID =0

    override fun onCreate() {
        super.onCreate()


        file = this.getSharedPreferences("savedData", MODE_PRIVATE)

        file.registerOnSharedPreferenceChangeListener(this)

        indicator = file.getBoolean("indicator", false)

        getList()

        language = file.getString("My_Lang", "en") ?: "en"

         previousStationID  =file.getInt("previousService",0)

        try {
            val inputStream = this.assets.open("metro_$language.json")
            val inputStreamReader = InputStreamReader(inputStream)
            val gson = Gson()
            stationData = gson.fromJson(inputStreamReader, Array<DataItem>::class.java)
        } catch (e: Exception) {
            Log.e("JSON", "Error reading JSON file: ${e.message}")
        }



    }

    override fun onSharedPreferenceChanged(sharedPreferences: SharedPreferences?, key: String?) {

        when (key) {
            "indicator" -> {
                if (sharedPreferences != null) {
                    indicator = sharedPreferences.getBoolean(key, false)


                }
            }
            "path" -> {
                if (sharedPreferences != null) {
                    getList()
                }
            }
            "My_Lang" -> {
                if (sharedPreferences != null) {
                    language = file.getString("My_Lang", "en") ?: "en"
                    try {
                        val inputStream = this.assets.open("metro_$language.json")
                        val inputStreamReader = InputStreamReader(inputStream)
                        val gson = Gson()
                        stationData = gson.fromJson(inputStreamReader, Array<DataItem>::class.java)
                    } catch (e: Exception) {
                        Log.e("JSON", "Error reading JSON file: ${e.message}")
                    }

                }
            }
            "previousService" ->{
                if (sharedPreferences != null) {
                    previousStationID = sharedPreferences.getInt(key, 0)
                }
            }
        }

    }

    private fun getList() {

            val gson = Gson()
            val json = file.getString("path", null)
            path = gson.fromJson(json, Array<String>::class.java) ?: emptyArray()



    }






}