import UIKit
import Flutter
import AVFoundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let flashlightChannel = FlutterMethodChannel(name: "com.example.flashlight/flashlight",
                                                  binaryMessenger: controller.binaryMessenger)

    flashlightChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "toggleFlashlight" {
        self.toggleFlashlight(result: result)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func toggleFlashlight(result: FlutterResult) {
    guard let device = AVCaptureDevice.default(for: .video) else {
      result(FlutterError(code: "UNAVAILABLE", message: "Flashlight not available", details: nil))
      return
    }
    
    if device.hasTorch {
      do {
        try device.lockForConfiguration()
        if device.torchMode == .on {
          device.torchMode = .off
        } else {
          try device.setTorchModeOn(level: 1.0)
        }
        device.unlockForConfiguration()
        result(device.torchMode == .on)
      } catch {
        result(FlutterError(code: "ERROR", message: "Could not toggle flashlight", details: nil))
      }
    } else {
      result(FlutterError(code: "UNAVAILABLE", message: "Flashlight not available", details: nil))
    }
  }
}
