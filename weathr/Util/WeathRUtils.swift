import Foundation
import UIKit

struct WeathR {
    
    static func applyTheme(_ navigationBar:UINavigationBar?) {
        navigationBar?.isTranslucent = false
        navigationBar?.tintColor = ColorPalette.forecastColor(index: 0)
        navigationBar?.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationBar?.shadowImage = UIImage()
      navigationBar?.titleTextAttributes = [NSAttributedStringKey.foregroundColor:ColorPalette.forecastColor(index: 0)]
    }
}

extension String {
    
    var capitalizeFirst: String {
        if isEmpty { return "" }
        var result = self
        result.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).uppercased())
        return result
    }
    
}

func average(numbers: Int...) -> Double {
    var sum = 0
    for number in numbers {
        sum += number
    }
    var average : Double = Double(sum) / Double(numbers.count)
    return average
}

func dateEpochToReadableDate(dateDouble: Double) -> String {
    let date = Date(timeIntervalSince1970: dateDouble)
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = DateFormatter.Style.medium
    let localDate = dateFormatter.string(from: date)
    return localDate
}
