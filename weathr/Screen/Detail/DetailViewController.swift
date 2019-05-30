import UIKit

class DetailViewController: ViewController<DetailViewModel> {
    
    // MARK: - IBOutlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var maxTempTitleLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempTitleLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.backgroundColor = ColorPalette.forecastColor(index: 0)
        
        observeDetailedForecast()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.detailedForecast.removeObservers(forOwner: self)
    }
    
    private func observeDetailedForecast() {
        
        viewModel.detailedForecast.addObserver(forOwner: self) { [unowned self] (_, newValue) in
            if let date = newValue?.date {
                self.dateLabel.text = dateEpochToReadableDate(dateDouble: date)
            }
            self.dateLabel.font = FontFamily.Roboto.regular.font(size: 20)
            self.dateLabel.textColor = ColorPalette.whiteTextColor
            
            self.temperatureLabel.text = L10n.homeTemperature(String(format:"%.f", average(numbers: Int(newValue?.temp.min ?? 0), Int(newValue?.temp.max ?? 0))))
            self.temperatureLabel.font = FontFamily.Roboto.regular.font(size: 30)
            self.temperatureLabel.textColor = ColorPalette.whiteTextColor
            
            self.maxTempTitleLabel.text = L10n.detailMaxTempTitle
            self.maxTempTitleLabel.font = FontFamily.Roboto.regular.font(size: 18)
            self.maxTempTitleLabel.textColor = ColorPalette.whiteTextColor
            
            self.maxTempLabel.text = L10n.detailTemperatureCelcius(String(newValue?.temp.max ?? 0))
            self.maxTempLabel.font = FontFamily.Roboto.regular.font(size: 18)
            self.maxTempLabel.textColor = ColorPalette.whiteTextColor
            
            self.minTempTitleLabel.text = L10n.detailMinTempTitle
            self.minTempTitleLabel.font = FontFamily.Roboto.regular.font(size: 18)
            self.minTempTitleLabel.textColor = ColorPalette.whiteTextColor
            
            self.minTempLabel.text = L10n.detailTemperatureCelcius(String(newValue?.temp.min ?? 0))
            self.minTempLabel.font = FontFamily.Roboto.regular.font(size: 18)
            self.minTempLabel.textColor = ColorPalette.whiteTextColor
            
            if let icon = newValue?.weather[0].icon {
                let downloadURL = NSURL(string: "http://openweathermap.org/img/w/\(icon).png")!
                self.iconImageView.af_setImage(withURL: downloadURL as URL)
            }
            
            if newValue == nil {
                
            } else {
                
            }
        }
    }
}
