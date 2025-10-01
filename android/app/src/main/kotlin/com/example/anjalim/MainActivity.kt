package com.example.anjalim

import android.app.ActivityManager
import android.graphics.Color
import android.os.Build
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onResume() {
        super.onResume()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            val taskDesc = ActivityManager.TaskDescription(
                "Students Gigs",        // Title in Recents screen
                R.mipmap.ic_launcher,   // App icon
                Color.parseColor("#FFFFFF") // Background color
            )
            setTaskDescription(taskDesc)
        }
    }
}
