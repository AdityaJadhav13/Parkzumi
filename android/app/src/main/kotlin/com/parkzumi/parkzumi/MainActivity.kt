package com.parkzumi.parkzumi

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * Bridges outside launches to Flutter: the companion bubble ("check here") and
 * text shared from Google Maps. Maps shares a place name and link, not coordinates.
 */
class MainActivity : FlutterActivity() {
    private var channel: MethodChannel? = null
    private var initial: Map<String, Any?>? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        initial = parse(intent)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).also { ch ->
            ch.setMethodCallHandler { call, result ->
                when (call.method) {
                    "initialIntent" -> {
                        result.success(initial)
                        initial = null
                    }
                    "status" -> result.success(
                        mapOf("canDrawOverlays" to canDrawOverlays(), "running" to CompanionService.running)
                    )
                    "requestOverlayPermission" -> {
                        startActivity(
                            Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse("package:$packageName"))
                        )
                        result.success(null)
                    }
                    "start" -> if (canDrawOverlays()) {
                        CompanionService.start(this)
                        result.success(true)
                    } else {
                        result.error("no_permission", "Display over other apps is not allowed", null)
                    }
                    "stop" -> {
                        CompanionService.stop(this)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
        }
    }

    // The bubble is for other apps; hide it while Parkzumi itself is on screen.
    override fun onResume() {
        super.onResume()
        CompanionService.appVisible = true
    }

    override fun onPause() {
        super.onPause()
        CompanionService.appVisible = false
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        parse(intent)?.let { channel?.invokeMethod("launchIntent", it) }
    }

    private fun canDrawOverlays() = Build.VERSION.SDK_INT < Build.VERSION_CODES.M || Settings.canDrawOverlays(this)

    private fun parse(i: Intent?): Map<String, Any?>? = when {
        i == null -> null
        i.action == ACTION_CHECK_HERE -> mapOf("type" to "checkHere")
        i.action == Intent.ACTION_SEND && i.type?.startsWith("text/") == true ->
            i.getStringExtra(Intent.EXTRA_TEXT)?.let { mapOf("type" to "sharedText", "text" to it.take(1000)) }
        else -> null
    }

    companion object {
        const val CHANNEL = "parkzumi/companion"
        const val ACTION_CHECK_HERE = "com.parkzumi.CHECK_HERE"
    }
}
