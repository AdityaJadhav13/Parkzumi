package com.parkzumi.parkzumi

import android.app.Application
import android.content.pm.PackageManager
import sh.measure.android.Measure
import sh.measure.android.config.MeasureConfig

/**
 * Starts the Measure SDK (measure.sh) when credentials are configured in
 * android/local.properties (measure.apiKey / measure.apiUrl). Without them the
 * app runs with its own local diagnostics only.
 */
class ParkzumiApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        val meta = packageManager.getApplicationInfo(packageName, PackageManager.GET_META_DATA).metaData
        val key = meta?.getString("sh.measure.android.API_KEY")
        val url = meta?.getString("sh.measure.android.API_URL")
        if (!key.isNullOrBlank() && !url.isNullOrBlank()) {
            Measure.init(this, MeasureConfig())
        }
    }
}
