import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
      ) -> Bool {
        let data = url.absoluteString
        let controller = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "com.example.taskly/deeplink", binaryMessenger: controller.binaryMessenger)
        
        channel.invokeMethod("onDeepLink", arguments: data)
        return true
      }
}
