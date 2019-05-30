import UIKit

class ViewController<T: ViewModel>: UIViewController {
    
    var viewModel: T!
    
    private var noNetworkMessageLabel: UILabel?
    private var noNetworkBannerLabel: UILabel?
    
    @IBInspectable
    var shouldShowNavigationBar: Bool = true {
        didSet {
            //navigationController?.setNavigationBarHidden(!shouldShowNavigationBar, animated: true)
        }
    }
    
    @IBInspectable
    var shouldDisplayNoNetwork: Bool = true
    
    /*private let loader = Loader()
    internal var isLoading: Bool = false {
        didSet {
            updateLoading()
        }
    }*/
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WeathR.applyTheme(self.navigationController?.navigationBar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //setupLoading()
        //observeIsConnected()
        //observeServiceError()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //viewModel.isConnected.removeObservers(forOwner: self)
        //viewModel.networkError.removeObservers(forOwner: self)
    }
    
    // MARK: - Setup view
    
    /*private func setupLoading() {
        view.addSubview(loader)
        loader.frame = view.bounds
        view.bringSubview(toFront: loader)
        updateLoading()
    }
    private func updateLoading() {
        if isLoading {
            loader.start()
        } else {
            loader.stop()
        }
    }*/
    
    // MARK: - Observers
    
    private func observeIsConnected() {
        viewModel.isConnected.addObserver(forOwner: self) { [unowned self] (oldValue, newValue) in
            guard let newValue = newValue, oldValue != newValue else {
                return
            }
            
            if newValue {
                //self.isLoading = true
                /*self.viewModel.fetchData { [weak self] in
                    self?.isLoading = false
                    self?.toggleNoNetworkBanner(false)
                    self?.toggleNoNetworkMessage(false)
                }*/
            } else {
                self.toggleNoNetworkBanner(true)
                //self.isLoading = false
            }
        }
    }
    
    private func observeServiceError() {
        viewModel.networkError.addObserver(forOwner: self) { [unowned self] (oldValue, newValue) in
            
            if let newValue = newValue,
                case ServiceError.noNetwork = newValue {
                //self.isLoading = false
                self.toggleNoNetworkBanner(true)
                self.toggleNoNetworkMessage(true)
            } else if let oldValue = oldValue, case ServiceError.noNetwork = oldValue {
                self.toggleNoNetworkMessage(false)
                self.toggleNoNetworkBanner(false)
            }
        }
    }
    
    func toggleNoNetworkMessage(_ shouldShow: Bool) {
        
        if shouldShow {
            guard self.noNetworkMessageLabel == nil, shouldDisplayNoNetwork else {
                return
            }
            
            let noNetworkMessageLabel = UILabel()
            noNetworkMessageLabel.numberOfLines = 0
            //noNetworkMessageLabel.text = L10n.noNetworkMessage
            //noNetworkMessageLabel.font = FontFamily.Roboto.bold.font(size: 18)
            noNetworkMessageLabel.text = "No network connection"
            noNetworkMessageLabel.textColor = ColorPalette.mainColor
            noNetworkMessageLabel.textAlignment = .center
            noNetworkMessageLabel.backgroundColor = .white
            noNetworkMessageLabel.layer.cornerRadius = 20
            noNetworkMessageLabel.layer.borderColor = ColorPalette.mainColor.cgColor
            noNetworkMessageLabel.layer.borderWidth = 2
            noNetworkMessageLabel.layer.masksToBounds = true
            noNetworkMessageLabel.clipsToBounds = true
            view.addSubview(noNetworkMessageLabel)
            view.bringSubview(toFront: noNetworkMessageLabel)
            noNetworkMessageLabel.translatesAutoresizingMaskIntoConstraints = false
            noNetworkMessageLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4).isActive = true
            noNetworkMessageLabel.heightAnchor.constraint(equalToConstant: 158).isActive = true
            noNetworkMessageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            noNetworkMessageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            self.noNetworkMessageLabel = noNetworkMessageLabel
            
            noNetworkMessageLabel.alpha = 0
            UIView.animate(withDuration: 0.3, animations: {
                noNetworkMessageLabel.alpha = 1
            })
            
        } else {
            noNetworkMessageLabel?.removeFromSuperview()
            noNetworkMessageLabel = nil
        }
    }
    
    func toggleNoNetworkBanner(_ shouldShow: Bool) {
        if shouldShow {
            guard self.noNetworkBannerLabel == nil, shouldDisplayNoNetwork else {
                return
            }
            let noNetworkBannerLabel = UILabel()
            noNetworkBannerLabel.numberOfLines = 1
            noNetworkBannerLabel.backgroundColor = ColorPalette.mainColor
            //noNetworkBannerLabel.text = L10n.noNetworkBannerMessage
            //noNetworkBannerLabel.font = FontFamily.Roboto.regular.font(size: 14)
            //noNetworkBannerLabel.text = "No network connection"
            noNetworkBannerLabel.textColor = .white
            noNetworkBannerLabel.textAlignment = .center
            view.addSubview(noNetworkBannerLabel)
            view.bringSubview(toFront: noNetworkBannerLabel)
            noNetworkBannerLabel.translatesAutoresizingMaskIntoConstraints = false
            noNetworkBannerLabel.heightAnchor.constraint(equalToConstant: 24)
            noNetworkBannerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            noNetworkBannerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            noNetworkBannerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            let navBarBottom = ((navigationController?.navigationBar.frame.height ?? 0) + (navigationController?.navigationBar.frame.origin.y ?? 0))
            let top = shouldShowNavigationBar ? navBarBottom - 24 : -noNetworkBannerLabel.frame.height
            
            let dynamicTopAnchor = noNetworkBannerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: top)
            dynamicTopAnchor.isActive = true
            
            self.noNetworkBannerLabel = noNetworkBannerLabel
            
            UIView.animate(withDuration: 0.3, animations: {
                dynamicTopAnchor.constant = self.shouldShowNavigationBar ? navBarBottom : 0
                self.view.layoutIfNeeded()
            })
            
        } else {
            noNetworkBannerLabel?.removeFromSuperview()
            noNetworkBannerLabel = nil
        }
    }
}

extension ViewController {
    func displayAlert(title: String?, message: String?, completion: (() -> Void)? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        present(alertController, animated: true, completion: completion)
    }
}
