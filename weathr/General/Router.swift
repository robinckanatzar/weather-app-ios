import UIKit
import Swinject
import SafariServices

struct Router: RouterProtocol {
    
    let navigationController: UINavigationController
    let screenResolver: ScreenResolverProtocol
    
    var hasPresentedVC: Bool {
        return navigationController.presentedViewController != nil
    }
    
    func push<Screen: UIViewController>(_ screenType: Screen.Type, animated: Bool) {
        let viewController = screenResolver.resolve(screenType: screenType) as UIViewController
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func push<Screen: UIViewController, Arg1>(_ screenType: Screen.Type, animated: Bool, argument: Arg1) {
        let viewController = screenResolver.resolve(screenType: screenType, argument: argument) as UIViewController
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func present<Screen: UIViewController>(_ screenType: Screen.Type, animated: Bool) {
        let viewController = screenResolver.resolve(screenType: screenType) as UIViewController
        navigationController.present(viewController, animated: animated, completion: nil)
    }
    
    func present<Screen: UIViewController, Arg1>(_ screenType: Screen.Type, animated: Bool, argument: Arg1) {
        let viewController = screenResolver.resolve(screenType: screenType, argument: argument) as UIViewController
        navigationController.present(viewController, animated: animated, completion: nil)
    }
    
    func present(_ viewController: UIViewController, animated: Bool) {
        if let _ = navigationController.presentedViewController {
            self.navigationController.dismiss(animated: true, completion: {
                self.navigationController.present(viewController, animated: animated, completion: nil)
            })
        } else {
            navigationController.present(viewController, animated: animated, completion: nil)
        }
    }
    
    func replaceLast<Screen: UIViewController>(with screenType: Screen.Type, animated: Bool) {
        let viewController = screenResolver.resolve(screenType: screenType) as UIViewController
        var viewControllers = navigationController.viewControllers
        guard viewControllers.last != viewController else {
            print("Try to replace \(String(describing: viewControllers.last)) with \(String(describing: viewController.self)) => did nothing")
            return
        }
        viewControllers[viewControllers.count - 1] = viewController
        navigationController.setViewControllers(viewControllers, animated: animated)
    }
    
    func replaceLast<Screen: UIViewController, Arg1>(with screenType: Screen.Type, animated: Bool, argument: Arg1) {
        let viewController = screenResolver.resolve(screenType: screenType, argument: argument) as UIViewController
        var viewControllers = navigationController.viewControllers
        guard viewControllers.last != viewController else {
            print("Try to replace \(String(describing: viewControllers.last)) with \(String(describing: viewController.self)) => did nothing")
            return
        }
        viewControllers[viewControllers.count - 1] = viewController
        navigationController.setViewControllers(viewControllers, animated: animated)
    }
    
    func pop(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }
    
    func dismiss(animated: Bool, completion: (() -> Void)?) {
        navigationController.dismiss(animated: animated, completion: completion)
    }
    
    func dismissIfNeeded(animated: Bool, completion: (() -> Void)?) {
        if navigationController.presentedViewController != nil {
            navigationController.dismiss(animated: animated, completion: completion)
        } else {
            completion?()
        }
    }
}

extension Router {
    func openInSafari(with urlString: String) {
        if let url = URL(string: urlString) {
            let safariViewController = SFSafariViewController(url: url)
            if #available(iOS 11.0, *) {
                safariViewController.dismissButtonStyle = .close
            }
            present(safariViewController, animated: true)
        }
    }
}
