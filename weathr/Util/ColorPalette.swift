import UIKit

struct ColorPalette {
    static let mainColor = UIColor(red:0.1, green:0.66, blue:0.8, alpha:1)
    static let complementaryColor = UIColor(red:0.95, green:0.6, blue:0.05, alpha:1)
    
    static let whiteTextColor = UIColor(red:1, green:1, blue:1, alpha:1)
    
    struct Colors {
        static let watermelon: UInt = 0xFF5670
        static let yellow: UInt = 0xFFCE00
        static let darkMagenta: UInt = 0xA90097
        static let greenBlue: UInt = 0x08A4A9
    }
    
    static  func forecastColor(index pIndex:Int) -> UIColor {
        let arrayColor = [
            UIColor(hexString: Colors.watermelon),
            UIColor(hexString: Colors.yellow),
            UIColor(hexString: Colors.darkMagenta),
            UIColor(hexString: Colors.greenBlue),
            ]
        return arrayColor[(pIndex % arrayColor.count)]
    }
}

extension UIColor {
    
    convenience init(hexString: UInt, alphaVal: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hexString & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hexString & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hexString & 0x0000FF) / 255.0,
            alpha: alphaVal
        )
    }
}
