import Foundation

protocol ForecastServiceProtocol {
    func getWeatherForecast(with city: String, number_of_days: String, completion: @escaping ServiceResultCompletion<Forecast>)
}
