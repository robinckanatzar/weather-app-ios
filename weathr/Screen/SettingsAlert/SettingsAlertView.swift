import Foundation
import UIKit

class SettingsAlertView: ViewController<SettingsViewModel> {
    
    // MARK: - IBOutlets
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var numDaysTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    var delegate: SettingsAlertViewDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
    }
    
    func setupView() {
        alertView.layer.cornerRadius = 15
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    
        titleLabel.text = L10n.settingsTitle
        okButton.setTitle(L10n.settingsOkButton, for: .normal)
        cancelButton.setTitle(L10n.settingsCancelButton, for: .normal)
        
        let city = UserDefaults.standard.string(forKey: "city") ?? ""
        let numDays = UserDefaults.standard.string(forKey: "numDays") ?? ""
        cityTextField.text = city
        numDaysTextField.text = numDays
    }
    
    func animateView() {
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }
    
    // MARK - Actions
    @IBAction func didTapCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapOkButton(_ sender: Any) {
        
        UserDefaults.standard.set(cityTextField.text, forKey: "city")
        UserDefaults.standard.set(numDaysTextField.text, forKey: "numDays")
        
        delegate?.refreshList()
        
        self.dismiss(animated: true, completion: nil)
    }
}
