import Foundation

class ForecastService: Service {
    override var path: String {
        get {
            return "forecast/daily/"
        }
    }
}

extension ForecastService: ForecastServiceProtocol {
    func getWeatherForecast(with city: String, number_of_days: String, completion: @escaping (ServiceResult<Forecast>) -> Void) {
        let fullPath = "\(path)/?q=\(city)&cnt=\(number_of_days)&units=metric&APPID=" // TODO move app id
        clientHTTP.makeRequest(on: fullPath) { (result) in
            completion(result)
        }
    }
}
