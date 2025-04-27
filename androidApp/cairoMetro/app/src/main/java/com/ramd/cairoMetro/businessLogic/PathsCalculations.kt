package com.ramd.cairoMetro.businessLogic

import android.annotation.SuppressLint
import android.content.Context
import com.ramd.cairoMetro.R

class PathsCalculations {

   fun calculatePrice(path:List<String>): Int {
       val stationCount = path.size
        return when {
            stationCount <= 9 -> 8
            stationCount <= 16 -> 10
            stationCount <= 23 -> 15
            else -> 20
        }

    }


    @SuppressLint("StringFormatMatches")

    fun time(context: Context, path: List<String>): String {
        val pathCount = path.size
         if (pathCount * 3 / 60 >= 1) {
          return  context.getString(R.string.time_hrs_mins, (pathCount * 3) / 60, (pathCount * 3) % 60)
        }
        if (pathCount * 3 % 60 in 3..10) {
          return  context.getString(R.string.time_mins, (pathCount * 3) % 60)
        }
        else {
          return  context.getString(R.string.time_min, ((pathCount * 3) % 60).toString())
        }
    }


    @SuppressLint("StringFormatMatches")

    fun countStations(context: Context, path: List<String>):String = context.getString(R.string.station_no, path.size)


}