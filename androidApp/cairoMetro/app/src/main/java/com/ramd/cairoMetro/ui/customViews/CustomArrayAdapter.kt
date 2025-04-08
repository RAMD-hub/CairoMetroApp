package com.ramd.cairoMetro.ui.customViews

import android.content.Context
import android.widget.ArrayAdapter
import android.widget.Filter
import androidx.annotation.LayoutRes

class CustomArrayAdapter(
    context: Context,
    @LayoutRes private val layoutResource: Int,
    private val allItems: List<String>
) : ArrayAdapter<String>(context, layoutResource, allItems) {

    private val filteredItems = mutableListOf<String>()

    init {
        filteredItems.addAll(allItems)
    }

    override fun getCount(): Int = filteredItems.size

    override fun getItem(position: Int): String = filteredItems[position]

    override fun getFilter(): Filter {
        return object : Filter() {
            override fun performFiltering(constraint: CharSequence?): FilterResults {
                val results = FilterResults()

                if (constraint.isNullOrEmpty()) {
                    // Return all items if constraint is empty
                    results.values = allItems
                    results.count = allItems.size
                } else {
                    // Filter items that contain the constraint anywhere in the string
                    val query = constraint.toString().lowercase()
                    val filtered = allItems.filter {
                        it.lowercase().contains(query)
                    }
                    results.values = filtered
                    results.count = filtered.size
                }

                return results
            }

            @Suppress("UNCHECKED_CAST")
            override fun publishResults(constraint: CharSequence?, results: FilterResults) {
                filteredItems.clear()
                filteredItems.addAll(results.values as List<String>)
                notifyDataSetChanged()
            }
        }
    }
}