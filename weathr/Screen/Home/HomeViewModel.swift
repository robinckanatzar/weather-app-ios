import Foundation
import UIKit

class HomeViewModel: ViewModel {
    
    var dailyForecast: Observable<[DailyForecast]> {
        return forecastDataAccess.dailyForecastList
    }
    
    private var forecastDataAccess: ForecastDataAccessProtocol
    
    // MARK: - Lifecycle
    init(router: RouterProtocol, connectivity: ConnectivityProtocol, forecastDataAccess: ForecastDataAccessProtocol) {
        self.forecastDataAccess = forecastDataAccess
        super.init(router: router, connectivity: connectivity)
        fetchData() {}
    }
    
    override func fetchData(completion: @escaping () -> ()) {
        let city = UserDefaults.standard.string(forKey: "city") ?? "Paris"
        let numDays = UserDefaults.standard.string(forKey: "numDays") ?? "5"
        
        forecastDataAccess.getWeatherForecast(with: city, number_of_days: numDays, completion: { (result, error) in
            self.networkError.value = error
            completion()
        })
    }
    
    func itemSelectedAtIndex(indexPath: IndexPath) {
        guard let dailyForecast = self.dailyForecast.value?[indexPath.row] else {
            print("daily forecast not found")
            return
        }
        router.push(DetailViewController.self, animated: true, argument : dailyForecast)
    }
}
