package com.ramd.cairoMetro.ui.activities

import android.annotation.SuppressLint
import android.content.Intent
import android.content.res.Configuration
import android.os.Bundle
import android.view.View

import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import androidx.core.view.isVisible
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.ramd.cairoMetro.R
import com.ramd.cairoMetro.databinding.ActivityAllRoutesBinding
import com.ramd.cairoMetro.coreApp.Application
import com.ramd.cairoMetro.data.DataItem
import com.ramd.cairoMetro.businessLogic.Direction
import com.ramd.cairoMetro.data.DataHandling
import com.ramd.cairoMetro.businessLogic.PathsAlgorithms
import com.ramd.cairoMetro.businessLogic.PathsCalculations
import com.ramd.cairoMetro.ui.customViews.StationItem
import com.xwray.groupie.GroupieAdapter
import java.util.ArrayList
import java.util.Locale

class AllRoutes : AppCompatActivity() {
    lateinit var binding: ActivityAllRoutesBinding
    var stationData: Array<DataItem> = emptyArray()
    lateinit var readAndWriteData : DataHandling
    var paths  = listOf<List<String>>()
    var sorting = emptyList<List<String>>()
    val items = mutableListOf<StationItem>()
    val pathsCalculations = PathsCalculations()
    var adapter = GroupieAdapter()
    var index =0  ; var indexPlus = 1 ;var  indexMins = 0
    var language="" ;
    var direction = Direction(stationData)

    @SuppressLint("SetTextI18n", "StringFormatMatches")
    override fun onCreate(savedInstanceState: Bundle?) {

        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        binding= ActivityAllRoutesBinding.inflate(layoutInflater)
        setContentView(binding.root)
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }

        setUp()


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

    @SuppressLint("StringFormatMatches")
    private fun setUp(){
        val application = application as Application
        stationData = application.stationData
        readAndWriteData = application.readAndWriteData
        language = application.language
        loadLocale()

        val startStation = intent.getStringExtra("startStation")
        val arrivalStation = intent.getStringExtra("arrivalStation")
        val shortType = intent.getBooleanExtra("shortType",false)
        val tripAvailability =  intent.getBooleanExtra("tripAvailability",false)

        val pathsAlgorithms = PathsAlgorithms(stationData)

        if(!startStation.isNullOrEmpty() && !arrivalStation.isNullOrEmpty()) {
            paths = pathsAlgorithms.findAllPaths(startStation,arrivalStation)
            if (paths.size > 1) {
                binding.control.isVisible= true
                binding.nextBtn.isEnabled=true
                binding.numberText.text = "${1} / ${paths.size}"
            }
            else {
                binding.control.isVisible= false
            }
        }

        direction = Direction(stationData)

        sorting = if (!shortType) {

            direction.sortingByStations(paths)

        } else {
            direction.sortingByIntersections(paths)
        }

        kitkatDialog(sorting[0])

        setRecyclerList(sorting[0])
        binding.notesText.isVisible =true
        binding.priceText.text = getString(R.string.price, pathsCalculations.calculatePrice(sorting[0]))

        binding.startBtn.isEnabled = tripAvailability
    }

    private fun kitkatDialog(path: List<String>) {
        val directionKitkat = direction.direction(path, this)
        if (directionKitkat.isNotEmpty() ) {
            dialog(directionKitkat)
        }
    }


    override fun onDestroy() {
        items.clear()
        adapter.clear()
        stationData = emptyArray()
        super.onDestroy()
    }

    @SuppressLint("SetTextI18n")
    fun next(view: View) {

        binding.notesText.isVisible = sorting[indexPlus] == sorting[0]
        index = indexPlus
        kitkatDialog(sorting[index])
        setRecyclerList(sorting[indexPlus])
        indexMins=indexPlus
        binding.numberText.text= "${indexMins+1} / ${sorting.size}"
        indexPlus++
        if(indexPlus>1)
        {
            binding.backBtn.isEnabled=true
        }
        if(indexPlus > (sorting.size-1)) {
            binding.nextBtn.isEnabled = false
            return
        }
    }

    fun back(view: View) {
        binding.nextBtn.isEnabled=true ;
        indexPlus=indexMins
        binding.numberText.text= "${indexMins} / ${sorting.size}"
        indexMins--
        binding.notesText.isVisible = sorting[indexMins] == sorting[0]
        setRecyclerList(sorting[indexMins])
        if(indexMins <= 0){ binding.backBtn.isEnabled=false ;indexPlus=1 ;return}
        index = indexMins
    }

    fun start(view: View) {
            MaterialAlertDialogBuilder(this, R.style.CustomAlertDialogTheme)
                .setTitle(getString(R.string.start_trip_tracking))
                .setMessage(getString(R.string.this_will_start_tracking_your_location_and_may_consume_battery))
                .setPositiveButton(getString(R.string.start_trip)) { _, _ ->

                    readAndWriteData.saveListData(this, sorting[index].toTypedArray(), "path")
                    val b = Intent(this, TripProgress::class.java)
                    b.putExtra("allRoutesPath", sorting[index] as ArrayList<String>)
                    startActivity(b)
                }
                .setNegativeButton(getString(R.string.cancel_trip)) { _, _ ->
                    // Respond to positive button press
                }
                .show()
    }

    fun dialog(text:String)
    {
        MaterialAlertDialogBuilder(this, R.style.CustomAlertDialogTheme)
            .setMessage(text)
            .setPositiveButton(getString(R.string.ok)) { _, _ ->
            }
            .show()
    }

    @SuppressLint("StringFormatMatches")
    fun setRecyclerList (path:List<String>){
        items.clear()
        val direction = Direction(stationData)
        var line =""
        val intersections = direction.findIntersections(path)
        for (index in path.indices)
        {
            if(index != path.size-1)
                line = direction.findLine(path[index], path[index + 1])


            if (index == 0 )
                items.add( StationItem(path[index], start = true , context = this, line =line ))
            else if ( index == path.size-1)
                items.add( StationItem(path[index], end = true, context = this,line =line))
            else if(path[index] in  intersections)
                items.add( StationItem(path[index], change = true, context = this,line =line))
            else
            {
                items.add( StationItem(path[index], context = this))
            }
        }
        adapter = GroupieAdapter()
        adapter.addAll(items)
        binding.StationsLV.adapter= adapter
        binding.stationText.text= pathsCalculations.countStations(this,path)
        binding.timeText.text = pathsCalculations.time(this,path)
    }




}