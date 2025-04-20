package com.ramd.cairoMetro.data

import android.content.Context
import android.content.SharedPreferences
import android.util.Log
import androidx.appcompat.app.AppCompatActivity.MODE_PRIVATE
import androidx.core.content.edit
import com.google.gson.Gson

class DataHandling {

    fun homeDataSave (context: Context,stationData: Array<DataItem>, shortRoute:Boolean = false, arrival:String  = "", start:String = ""){

        val home =context.getSharedPreferences("homeData", MODE_PRIVATE)

        val  startID = stationData.firstOrNull { it.name == start }?.id
        val arrivalID = stationData.firstOrNull { it.name == arrival }?.id
        home.edit {
            putBoolean("shortRoute", shortRoute)
            if (arrivalID != null) {
                putInt("arrivalID",arrivalID)
            }
            if (startID != null) {
                putInt("startID",startID)
            }
        }
    }


    fun extractPathId (context: Context,path:List<String>,stationData: Array<DataItem>)
    {   val file: SharedPreferences =context.getSharedPreferences("savedData", MODE_PRIVATE)
        val pathChanged = mutableListOf<Int>()
        for (s in path) {
          val station =   stationData.firstOrNull() { it.name== s }?.id
            if (station!= null){
            pathChanged.add(station)
            }
        }

        val gson = Gson()
        val json = gson.toJson(pathChanged)
        file.edit {
            putString("path_language", json)
        }

    }

    fun getPathData (context: Context, stationData: Array<DataItem>):List<String>
    {   val pathChanged = mutableListOf<String>()
        val file: SharedPreferences =context.getSharedPreferences("savedData", MODE_PRIVATE)
        val gson = Gson()
        val json = file.getString("path_language", null)
        val pathID =  gson.fromJson(json, Array<Int>::class.java) ?: emptyArray()

        if(pathID.isNotEmpty()) {

            for (s in pathID) {
                pathChanged.add(stationData.first { it.id == s }.name)
            }

        }

        return pathChanged.toList()
    }



    fun saveID(context: Context, data:Int, key:String) {
        val file: SharedPreferences =context.getSharedPreferences("savedData", MODE_PRIVATE)
        file.edit {
            putInt(key, data)
        }
    }


    fun getSimpleData( context: Context,key:String): Boolean {
        val file: SharedPreferences = context.getSharedPreferences("savedData", MODE_PRIVATE)
        val data = file.getBoolean(key, false)
        return data
    }

    fun saveSimpleData(context: Context,data:Boolean,key:String) {
        val file: SharedPreferences =context.getSharedPreferences("savedData", MODE_PRIVATE)
        file.edit {
            putBoolean(key, data)
        }
    }




    fun saveListData(context: Context,data:Array<String>,key:String) {
        val file: SharedPreferences =context.getSharedPreferences("savedData", MODE_PRIVATE)
        val gson = Gson()
        val json = gson.toJson(data)
        file.edit {
            putString(key, json)
        }
    }





}