import Foundation

protocol ForecastDataAccessProtocol: DataAccessProtocol {
    var dailyForecastList: Observable<[DailyForecast]> { get }
    func getWeatherForecast(with city: String, number_of_days: String, completion: @escaping (Forecast?, ServiceError?) -> Void)
}
