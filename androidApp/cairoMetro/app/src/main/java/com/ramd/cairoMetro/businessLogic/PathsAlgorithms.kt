package com.ramd.cairoMetro.businessLogic

import com.ramd.cairoMetro.data.DataItem


class PathsAlgorithms (private val data:Array<DataItem>){




    fun findAllPaths(start: String, end: String): List<List<String>> {

        val visited = mutableSetOf<String>()
        val path = mutableListOf<String>()
        val result = mutableListOf<List<String>>()
        dfs(start, end, visited, path, result)
        return result
    }

    private fun dfs(
        current: String,
        end: String,
        visited: MutableSet<String>,
        path: MutableList<String>,
        result: MutableList<List<String>>
    ){

        visited.add(current)
        path.add(current)

        if (current == end) {
            if(path !in result) {
                result.add(ArrayList(path))
            }
        } else {

            val currentClasses = data.filter { it.name == current }
            for (currentClass in currentClasses) {
                currentClass.neighbourStations.forEach { neighbor ->
                    if (!visited.contains(neighbor)) {
                        dfs(neighbor, end, visited, path, result)
                    }
                }
            }

        }
        visited.remove(current)
        path.removeAt(path.size - 1)

    }


}