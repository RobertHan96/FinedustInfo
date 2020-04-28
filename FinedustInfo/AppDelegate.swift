import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var navationController : UINavigationController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            let mainVC = MainViewController()
            navationController = UINavigationController(rootViewController: mainVC)
            window.rootViewController = navationController
            window.makeKeyAndVisible()
        }
        sleep(2)
        return true
    }
}

