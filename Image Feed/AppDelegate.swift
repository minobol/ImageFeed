import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                     launchOptions:[UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options connectionOptions: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Main", sessionRole: connectingSceneSession.role)
    }
}
