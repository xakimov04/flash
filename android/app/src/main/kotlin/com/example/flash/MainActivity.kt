package com.example.flash

import android.content.pm.PackageManager
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.flashlight/flashlight"

    private var isFlashlightOn = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "toggleFlashlight") {
                val hasCameraFlash = packageManager.hasSystemFeature(PackageManager.FEATURE_CAMERA_FLASH)
                if (hasCameraFlash) {
                    if (ContextCompat.checkSelfPermission(this, android.Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
                        ActivityCompat.requestPermissions(this, arrayOf(android.Manifest.permission.CAMERA), 50)
                    } else {
                        toggleFlashlight()
                        result.success(isFlashlightOn)
                    }
                } else {
                    result.error("UNAVAILABLE", "Flashlight not available", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun toggleFlashlight() {
        val cameraManager = getSystemService(CAMERA_SERVICE) as android.hardware.camera2.CameraManager
        val cameraId = cameraManager.cameraIdList[0]
        isFlashlightOn = !isFlashlightOn
        cameraManager.setTorchMode(cameraId, isFlashlightOn)
    }
}
