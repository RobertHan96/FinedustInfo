import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var navationController : UINavigationController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            let mainVC = MainController()
            navationController = UINavigationController(rootViewController: mainVC)
            window.rootViewController = navationController
            window.makeKeyAndVisible()
        }
        if #available(iOS 13.0, *){
            self.window?.overrideUserInterfaceStyle = .light
        }
        
        sleep(2)
        return true
    }
}

