package com.ramd.cairoMetro.systemIntegration

import android.Manifest
import android.Manifest.permission.*
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import androidx.activity.result.ActivityResultLauncher
import androidx.core.content.ContextCompat

class Permissions (val context: Context) {

    val requiredPermissions = when {
        Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU -> {
            // Android 13+ requires POST_NOTIFICATIONS and FOREGROUND_SERVICE_LOCATION
            arrayOf(
                ACCESS_FINE_LOCATION,
                ACCESS_COARSE_LOCATION,
                ACCESS_BACKGROUND_LOCATION,
                FOREGROUND_SERVICE,
                POST_NOTIFICATIONS,
//                FOREGROUND_SERVICE_LOCATION
            )
        }
        Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q -> {
            // Android 10-12 requires ACCESS_BACKGROUND_LOCATION and FOREGROUND_SERVICE
            arrayOf(
                ACCESS_FINE_LOCATION,
                ACCESS_COARSE_LOCATION,
                ACCESS_BACKGROUND_LOCATION,
                FOREGROUND_SERVICE
            )
        }
        Build.VERSION.SDK_INT >= Build.VERSION_CODES.O -> {
            // Android 8.0-9.0 requires FOREGROUND_SERVICE
            arrayOf(
                ACCESS_FINE_LOCATION,
                ACCESS_COARSE_LOCATION,
//                FOREGROUND_SERVICE
            )
        }
        else -> {
            // Android 7.1 and below only needs location permissions
            arrayOf(
                ACCESS_FINE_LOCATION,
                ACCESS_COARSE_LOCATION
            )
        }
    }



    fun hasRequiredPermissions(): Boolean {
        return requiredPermissions.all {
            ContextCompat.checkSelfPermission(context, it) == PackageManager.PERMISSION_GRANTED
        }
    }

     fun requestLocationPermissions(permissionLauncher:ActivityResultLauncher<Array<String>>) {
         if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
             // Android 10 and above
             val foregroundPermissions = when {
                 Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU -> {
                     // Android 13+ requires POST_NOTIFICATIONS and FOREGROUND_SERVICE_LOCATION
                     arrayOf(
                         ACCESS_FINE_LOCATION,
                         ACCESS_COARSE_LOCATION,
                         FOREGROUND_SERVICE,
                         POST_NOTIFICATIONS,
//                         FOREGROUND_SERVICE_LOCATION
                     )
                 }
                 else -> {
                     // Android 10-12 requires FOREGROUND_SERVICE
                     arrayOf(
                         ACCESS_FINE_LOCATION,
                         ACCESS_COARSE_LOCATION,
                         FOREGROUND_SERVICE
                     )
                 }
             }

             // Launch permission request for foreground permissions
             permissionLauncher.launch(foregroundPermissions)

             // Check if foreground permissions are granted before requesting background permission
             if (foregroundPermissions.all { permission ->
                     ContextCompat.checkSelfPermission(context, permission) == PackageManager.PERMISSION_GRANTED
                 }) {
                 // Request background location permission separately
                 permissionLauncher.launch(arrayOf(ACCESS_BACKGROUND_LOCATION))
             }
         } else {
             permissionLauncher.launch(arrayOf(
                 ACCESS_FINE_LOCATION,
                 ACCESS_COARSE_LOCATION
             ))
         }
    }

}