package com.parkzumi.parkzumi

import android.animation.ValueAnimator
import android.annotation.SuppressLint
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.graphics.PixelFormat
import android.os.Build
import android.os.IBinder
import android.view.Gravity
import android.view.MotionEvent
import android.view.View
import android.view.ViewConfiguration
import android.view.WindowManager
import android.widget.ImageView
import kotlin.math.abs

/**
 * The user-enabled floating Zumi bubble. It draws only its own small view over
 * other apps (e.g. Google Maps); it does not read the screen or know what app
 * is in front. Tapping it opens Parkzumi straight into "check where I am".
 */
class CompanionService : Service() {
    private lateinit var wm: WindowManager
    private var bubble: View? = null

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()
        running = true
        instance = this
        startInForeground()
        addBubble()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == ACTION_STOP) {
            stopSelf()
            return START_NOT_STICKY
        }
        return START_STICKY
    }

    override fun onDestroy() {
        bubble?.let { runCatching { wm.removeView(it) } }
        bubble = null
        running = false
        instance = null
        super.onDestroy()
    }

    private fun startInForeground() {
        val nm = getSystemService(NotificationManager::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            nm.createNotificationChannel(
                NotificationChannel(CHANNEL_ID, "Floating companion", NotificationManager.IMPORTANCE_MIN)
            )
        }
        val open = PendingIntent.getActivity(
            this, 1, checkHereIntent(this), PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )
        val stop = PendingIntent.getService(
            this, 2, Intent(this, CompanionService::class.java).setAction(ACTION_STOP), PendingIntent.FLAG_IMMUTABLE
        )
        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, CHANNEL_ID)
        } else {
            @Suppress("DEPRECATION") Notification.Builder(this)
        }
        val notification = builder
            .setSmallIcon(R.drawable.ic_stat_zumi)
            .setContentTitle("Zumi is floating")
            .setContentText("Tap the bubble to check where you are.")
            .setContentIntent(open)
            .addAction(Notification.Action.Builder(null, "Turn off", stop).build())
            .setOngoing(true)
            .build()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            startForeground(NOTIFICATION_ID, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_SPECIAL_USE)
        } else {
            startForeground(NOTIFICATION_ID, notification)
        }
    }

    @SuppressLint("ClickableViewAccessibility")
    private fun addBubble() {
        wm = getSystemService(WINDOW_SERVICE) as WindowManager
        val density = resources.displayMetrics.density
        val size = (60 * density).toInt()
        val margin = (8 * density).toInt()
        val screenW = resources.displayMetrics.widthPixels
        val type = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        } else {
            @Suppress("DEPRECATION") WindowManager.LayoutParams.TYPE_PHONE
        }
        val lp = WindowManager.LayoutParams(
            size, size, type, WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE, PixelFormat.TRANSLUCENT
        ).apply {
            gravity = Gravity.TOP or Gravity.START
            x = screenW - size - margin
            y = resources.displayMetrics.heightPixels / 3
        }
        val view = ImageView(this).apply {
            setImageResource(R.drawable.zumi_bubble)
            contentDescription = "Parkzumi: check parking where I am"
            elevation = 8 * density
        }
        val slop = ViewConfiguration.get(this).scaledTouchSlop
        var downX = 0f
        var downY = 0f
        var startX = 0
        var startY = 0
        var dragging = false
        view.setOnTouchListener { v, e ->
            when (e.actionMasked) {
                MotionEvent.ACTION_DOWN -> {
                    downX = e.rawX; downY = e.rawY; startX = lp.x; startY = lp.y; dragging = false
                    v.animate().scaleX(0.92f).scaleY(0.92f).setDuration(120).start()
                }
                MotionEvent.ACTION_MOVE -> {
                    val dx = e.rawX - downX
                    val dy = e.rawY - downY
                    if (!dragging && (abs(dx) > slop || abs(dy) > slop)) dragging = true
                    if (dragging) {
                        lp.x = startX + dx.toInt()
                        lp.y = startY + dy.toInt()
                        wm.updateViewLayout(v, lp)
                    }
                }
                MotionEvent.ACTION_UP, MotionEvent.ACTION_CANCEL -> {
                    v.animate().scaleX(1f).scaleY(1f).setDuration(120).start()
                    if (!dragging && e.actionMasked == MotionEvent.ACTION_UP) {
                        v.performHapticFeedback(android.view.HapticFeedbackConstants.VIRTUAL_KEY)
                        startActivity(checkHereIntent(this))
                    } else {
                        // Snap to the nearest edge so it never covers the middle of the map.
                        val target = if (lp.x + size / 2 < screenW / 2) margin else screenW - size - margin
                        ValueAnimator.ofInt(lp.x, target).apply {
                            duration = 240
                            addUpdateListener {
                                lp.x = it.animatedValue as Int
                                runCatching { wm.updateViewLayout(v, lp) }
                            }
                            start()
                        }
                    }
                }
            }
            true
        }
        view.visibility = if (appVisible) View.GONE else View.VISIBLE
        wm.addView(view, lp)
        bubble = view
    }

    companion object {
        @Volatile
        var running = false
            private set

        private var instance: CompanionService? = null

        /** Set by MainActivity; the bubble shows only while Parkzumi is not on screen. */
        var appVisible = false
            set(value) {
                field = value
                instance?.bubble?.visibility = if (value) View.GONE else View.VISIBLE
            }

        private const val CHANNEL_ID = "companion"
        private const val NOTIFICATION_ID = 7
        private const val ACTION_STOP = "com.parkzumi.COMPANION_STOP"

        fun checkHereIntent(context: Context): Intent =
            Intent(context, MainActivity::class.java)
                .setAction(MainActivity.ACTION_CHECK_HERE)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)

        fun start(context: Context) {
            val i = Intent(context, CompanionService::class.java)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) context.startForegroundService(i) else context.startService(i)
        }

        fun stop(context: Context) {
            context.stopService(Intent(context, CompanionService::class.java))
        }
    }
}
