import Foundation

class ForecastDataAccess {
    
    let dailyForecastList = Observable<[DailyForecast]>()
    
    // MARK: - Variables
    fileprivate let service: ForecastServiceProtocol
    
    // MARK: - Lifecycle
    init(service: ForecastServiceProtocol) {
        self.service = service
    }
}

// MARK: - DataAccessProtocol
extension ForecastDataAccess {
    func clearData() {
        dailyForecastList.value = nil
    }
}

extension ForecastDataAccess: ForecastDataAccessProtocol {
    func getWeatherForecast(with city: String, number_of_days: String, completion: @escaping (Forecast?, ServiceError?) -> Void) {
        service.getWeatherForecast(with: city, number_of_days: number_of_days) { (result) in
            switch result {
            case .success(let item):
                let items = item.dailyForecasts
                self.dailyForecastList.value = items.sorted() { $0.date < $1.date }
                completion(nil, nil)
            case .failure(let error):
                print("\(error)")
                completion(nil, error)
            }
        }
    }
}
