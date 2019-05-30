import UIKit

protocol RouterProtocol {
    var hasPresentedVC: Bool { get }
    func push<Screen: UIViewController>(_ screenType: Screen.Type, animated: Bool)
    func push<Screen: UIViewController, Arg1>(_ screenType: Screen.Type, animated: Bool, argument: Arg1)
    func present<Screen: UIViewController>(_ screenType: Screen.Type, animated: Bool)
    func present<Screen: UIViewController, Arg1>(_ screenType: Screen.Type, animated: Bool, argument: Arg1)
    func present(_ viewController: UIViewController, animated: Bool)
    func replaceLast<Screen: UIViewController>(with screenType: Screen.Type, animated: Bool)
    func replaceLast<Screen: UIViewController, Arg1>(with screenType: Screen.Type, animated: Bool, argument: Arg1)
    func pop(animated: Bool)
    func dismiss(animated: Bool, completion: (() -> Void)?)
    func dismissIfNeeded(animated: Bool, completion: (() -> Void)?)
    func openInSafari(with urlString: String)
}

extension RouterProtocol {
    
    func pop(animated: Bool = true) {
        pop(animated: animated)
    }
    
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        dismiss(animated: animated, completion: completion)
    }
}
