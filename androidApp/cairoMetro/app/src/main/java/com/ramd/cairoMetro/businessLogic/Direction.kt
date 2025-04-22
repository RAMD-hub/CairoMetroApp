package com.ramd.cairoMetro.businessLogic

import android.content.Context
import com.ramd.cairoMetro.R
import com.ramd.cairoMetro.data.DataItem

class Direction( val data:Array<DataItem> ) {


    fun sortingByIntersections(paths: List<List<String>>): List<List<String>> {

        val sortedPaths = paths.sortedBy { findIntersections(it).size }
        return sortedPaths
    }

    fun findLine(first: String, second: String): String {
        var lineName = ""
        val firstStation = data.filter { it.name == first }
        val secondStation = data.filter { it.name == second }

        for (dataItem1 in firstStation) {
            for (dataItem2 in secondStation) {
                if (dataItem2.line == dataItem1.line) {
                    lineName = dataItem2.line

                }
            }
        }
        return lineName
    }


    fun findIntersections(path: List<String>): MutableList<String> {

        val intersections = mutableListOf<String>()
        var lineName = findLine(path[0], path[1])
        val intersectionStations = data.filter { it.intersection }.map { it.name }.toSet()
        for (index in path.indices) {
            if ((index + 1) < path.size) {
                val nextStation = data.filter { it.name == path[index + 1] }.map { it.line }
                val station = path[index]
                if (station in intersectionStations && !nextStation.contains(lineName)) {
                    intersections.add(station)
                    lineName = findLine(station, path[index + 1])
                }
            }
        }
        return intersections

    }


    fun direction(path: List<String>, context: Context): String {
        if (path.isEmpty()) return ""
        
        val kitKatName = context.getString(R.string.kit_kat)
        val sudan = context.getString(R.string.sudan)
        val tawfikia = context.getString(R.string.tawfikia)
        val safaHegezy = context.getString(R.string.safa_hegazy)

        if (!path.contains(kitKatName)) return ""

        return when (val kitkatIndex = path.indexOf(kitKatName)) {
            0 -> when (path[1]) {
                sudan -> messages(context,1)
                tawfikia -> messages(context,2)
                else -> ""
            }
            path.size-1 -> ""
            else -> when {
                path[kitkatIndex + 1] == sudan && path[kitkatIndex - 1] == tawfikia ->
                    "${messages(context,3)} ${messages(context,1)}"

                path[kitkatIndex + 1] == tawfikia && path[kitkatIndex - 1] == sudan ->
                    "${messages(context,3)} ${messages(context,2)}"

                path[kitkatIndex + 1] == tawfikia && path[kitkatIndex - 1] == safaHegezy ->
                    messages(context,2)

                path[kitkatIndex + 1] == sudan && path[kitkatIndex - 1] == safaHegezy ->
                    messages(context,1)

                else -> ""
            }
        }
    }

    fun messages (context: Context,no:Int):String
    {
       return when(no){
            1 -> context.getString(R.string.make_sure_to_take_metro_in_direction_from_kit_kat_to_rod_el_farag_corridor)
            2-> context.getString(R.string.make_sure_to_take_metro_in_direction_from_kit_kat_to_cairo_university_el_monib)
            3-> context.getString(R.string.then_come_out_wait_the_next_metro_and)
           else -> ""
       }

    }


}