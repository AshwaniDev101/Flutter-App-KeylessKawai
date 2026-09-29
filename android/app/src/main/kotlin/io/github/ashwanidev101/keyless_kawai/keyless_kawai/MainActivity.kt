package io.github.ashwanidev101.keyless_kawai.keyless_kawai

import android.content.Intent
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity

// Test command
// adb shell am start -a android.intent.action.VIEW -n io.github.ashwanidev101.keyless_kawai.keyless_kawai/.MainActivity --es door_command "LOCK_TRIGGER"

// TODO: PLAY CONSOLE VOICE INTEGRATION
// 1. Build an App Bundle (.aab).
// 2. Upload to Google Play Console (Internal Testing Track).
// 3. This registers shortcuts.xml with Google's Cloud.
// 4. Once synced, "Hey Google, open door in Keyless Kawai" will natively trigger this intent.
// Note: Requires $25 lifetime Play Console developer fee.

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent?) {
        // Look for the "door_command" extra we defined in shortcuts.xml
        val command = intent?.getStringExtra("door_command")

        if (command != null) {
            Log.d("MainActivity", "App Action triggered with: $command")

            // Reusing your existing UnlockService logic
            val serviceIntent = Intent(this, UnlockService::class.java).apply {
                putExtra("CMD", "LOCK_TRIGGER") // Or pass the command dynamically
            }

            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                startForegroundService(serviceIntent)
            } else {
                startService(serviceIntent)
            }
        }
    }
}