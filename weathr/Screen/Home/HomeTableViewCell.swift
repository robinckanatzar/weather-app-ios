import UIKit
import Alamofire
import AlamofireImage

class HomeTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var backgroundCardView: UIView!
    
    func configure(date: Double, imageId: String, tempMin: Double, tempMax: Double) {
        
        let downloadURL = NSURL(string: "http://openweathermap.org/img/w/\(imageId).png")!
        iconImageView.af_setImage(withURL: downloadURL as URL)
        
        dateLabel.text = dateEpochToReadableDate(dateDouble: date)
        
        temperatureLabel.text = L10n.homeTemperature(String(format:"%.f", average(numbers: Int(tempMin), Int(tempMax))))
        
        backgroundCardView.layer.cornerRadius = 10
        backgroundCardView.backgroundColor = ColorPalette.forecastColor(index: 0)
        dateLabel.textColor = ColorPalette.whiteTextColor
        dateLabel.font = FontFamily.Roboto.bold.font(size: 20)
        temperatureLabel.textColor = ColorPalette.whiteTextColor
        temperatureLabel.font = FontFamily.Roboto.bold.font(size: 30)
        
        selectionStyle = .none
    }
    
    
}

