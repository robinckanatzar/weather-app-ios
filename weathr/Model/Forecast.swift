import UIKit
import Marshal

struct Forecast {
    let city: City
    let dailyForecasts: [DailyForecast]
}

extension Forecast: Unmarshaling {
    
    init(object: MarshaledObject) throws {
        city = try object.value(for: "city")
        dailyForecasts = try object.value(for: "list")
    }
}
