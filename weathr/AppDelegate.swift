import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Constants
    private enum Constant {
        static let firstScreenToLaunch = LaunchScreenViewController.self
    }
    
    // MARK: - Variables
    var window: UIWindow?
    var container: AppContainer?
    
    private var screenResolver: ScreenResolverProtocol {
        guard let screenResolver = container?.resolve(ScreenResolverProtocol.self) else {
            fatalError("screenResolver should be ready")
        }
        return screenResolver
    }
  
    // MARK: - Delegates methods
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        instantiateWindow()
        let navigationController = UINavigationController()
        container = AppContainer(navigationController: navigationController)
        setupFirstViewController(navigationController, screenResolver: screenResolver)
        
        return true
    }
  
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
  
    // MARK: - Window init
    private func instantiateWindow() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        self.window = window
    }
    
    // MARK: - First View Controller
    private func setupFirstViewController(_ navigationController: UINavigationController, screenResolver: ScreenResolverProtocol) {
        guard let window = self.window else {
            fatalError("Window should be ready here")
        }
        
        let firstViewController = screenResolver.resolve(screenType: Constant.firstScreenToLaunch)
        navigationController.setViewControllers([firstViewController], animated: false)
        window.rootViewController = navigationController
    }
}

