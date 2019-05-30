import UIKit

class DetailViewModel: ViewModel {
    
    private weak var forecastDataAccess: ForecastDataAccessProtocol!
    
    // MARK: - Variable
    var detailedForecast = Observable<DailyForecast>()
    private let forecastDetails: DailyForecast
    
    init(router: RouterProtocol, connectivity: ConnectivityProtocol, forecastDetails: DailyForecast) {
        self.forecastDetails = forecastDetails
        self.detailedForecast.value = forecastDetails
        super.init(router: router, connectivity: connectivity)
    }
}
