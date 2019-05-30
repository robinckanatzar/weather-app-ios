import UIKit

class SettingsViewModel: ViewModel {
    
    private weak var forecastDataAccess: ForecastDataAccessProtocol!
    
    init(router: RouterProtocol, connectivity: ConnectivityProtocol, forecastDataAccess: ForecastDataAccessProtocol) {
        self.forecastDataAccess = forecastDataAccess
        super.init(router: router, connectivity: connectivity)
    }
}
