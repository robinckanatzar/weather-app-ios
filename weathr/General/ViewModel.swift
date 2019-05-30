import UIKit
import CoreMotion

class ViewModel {
    internal let router: RouterProtocol
    internal let connectivity: ConnectivityProtocol
    
    var isConnected: Observable<Bool> {
        return connectivity.isConnected
    }
    
    let networkError = Observable<ServiceError>()
    
    init(router: RouterProtocol, connectivity: ConnectivityProtocol) {
        self.router = router
        self.connectivity = connectivity
    }
    
    func fetchData(completion: @escaping () -> ()) {
        
    }
    
    func present<Screen: UIViewController>(_ screenType: Screen.Type) {
        router.present(screenType, animated: true)
    }
    
    func goToMainScreen(withCountDown: Bool = true, hasSeenEndChallengeMessage: Bool = false) {
        router.replaceLast(with: HomeViewController.self, animated: true)
    }
}
