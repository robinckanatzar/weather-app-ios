import Foundation
import UIKit

extension HomeViewController: UITableViewDataSource {}
extension HomeViewController: UITableViewDelegate {}
extension HomeViewController: SettingsAlertViewDelegate {}

class HomeViewController: ViewController<HomeViewModel> {
  
  // MARK: - IBOutlet
  @IBOutlet weak var tableView: UITableView!
  
  private let refreshControl = UIRefreshControl()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = UserDefaults.standard.string(forKey: "city") ?? "Paris"
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    observeDailyForecastList()
    if #available(iOS 10.0, *) {
      tableView.refreshControl = refreshControl
    } else {
      tableView.addSubview(refreshControl)
    }
    refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
  }
  
  @objc func refreshData(_ sender: Any) {
    viewModel.fetchData { [weak self] in
      self?.title = UserDefaults.standard.string(forKey: "city") ?? "Paris"
      self?.refreshControl.endRefreshing()
      self?.tableView.reloadData()
      self?.title = UserDefaults.standard.string(forKey: "city") ?? "Paris"
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    viewModel.dailyForecast.removeObservers(forOwner: self)
  }
  
  private func observeDailyForecastList() {
    viewModel.dailyForecast.addObserver(forOwner: self) { [unowned self] (_, newValue) in
      guard newValue != nil else {
        return
      }
      
      self.tableView.reloadData()
      
      self.title = UserDefaults.standard.string(forKey: "city") ?? "Paris"
    }
  }
  
  // MARK - Actions
  @IBAction func didTapSettingsButton(_ sender: Any) {
    let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "SettingsAlertView") as! SettingsAlertView
    customAlert.providesPresentationContextTransitionStyle = true
    customAlert.definesPresentationContext = true
    customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
    customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    customAlert.delegate = self
    self.present(customAlert, animated: true, completion: nil)
  }
  
  func refreshList() {
    refreshData(self)
  }
    
  // UITableViewDataSource
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.dailyForecast.value?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
    if let dailyForecast = viewModel.dailyForecast.value?[indexPath.row] {
      cell.configure(date: dailyForecast.date, imageId: dailyForecast.weather[0].icon, tempMin: dailyForecast.temp.min, tempMax: dailyForecast.temp.max)
    }
    return cell
  }
  
  // UITableViewDelegate
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 300
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.itemSelectedAtIndex(indexPath: indexPath)
  }
  
}
