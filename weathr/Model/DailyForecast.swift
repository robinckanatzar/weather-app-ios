import Foundation
import Marshal

struct DailyForecast {
    let date: Double
    let temp: Temperature
    let weather: [Weather]
}

extension DailyForecast: Unmarshaling {
    
    init(object: MarshaledObject) throws {
        date = try object.value(for: "dt")
        temp = try object.value(for: "temp")
        weather = try object.value(for: "weather")
    }
}
