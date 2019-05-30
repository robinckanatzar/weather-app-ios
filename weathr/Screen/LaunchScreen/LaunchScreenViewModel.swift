import Foundation
import UIKit

class LaunchScreenViewModel: ViewModel {
    
    // MARK: - Variables
    private let forecastDataAccess: ForecastDataAccessProtocol
    
    // MARK: - Lifecycle
    init(router: RouterProtocol, connectivity: ConnectivityProtocol, forecastDataAccess: ForecastDataAccessProtocol) {
        self.forecastDataAccess = forecastDataAccess
        super.init(router: router, connectivity: connectivity)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            self.selectScreen()
        })
    }
    
    private func selectScreen() {
        router.replaceLast(with: HomeViewController.self, animated: true)
    }
}

