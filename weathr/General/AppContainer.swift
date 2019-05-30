import Foundation
import Swinject

class AppContainer: DependencyContainer {
    
    private unowned let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
    
    override func registerDependencies(in container: Container) {
        registerCommon(in: container)
        registerService(in: container)
        registerDataAccess(in: container)
        registerScreens(in: container)
    }
    
    private func registerCommon(in container: Container) {
        // Screen Resolver
        container.register(ScreenResolverProtocol.self) { r in
            return ScreenResolver(container: self)
            }.inObjectScope(.container)
        
        // Router
        container.register(RouterProtocol.self) { r in
            let screenResolver = r.resolve(ScreenResolverProtocol.self)!
            return Router(navigationController: self.navigationController, screenResolver: screenResolver)
            }.inObjectScope(.container)
        
        // Connectivity
        container.register(ConnectivityProtocol.self) { r in
            return Connectivity()
            }.inObjectScope(.container)
    }
    
    private func registerService(in container: Container) {
        
        container.register(ClientHTTPProtocol.self) { r in
            return ClientHTTP()
            }.inObjectScope(.weak)
        
        // Forecast Service
        container.register(ForecastServiceProtocol.self) { r in
            let clientHTTP = r.resolve(ClientHTTPProtocol.self)!
            return ForecastService(clientHTTP: clientHTTP)
            }.inObjectScope(.weak)
    }
    
    private func registerDataAccess(in container: Container) {
        // Forecast DataAccess
        container.register(ForecastDataAccessProtocol.self) { r in
            let service = r.resolve(ForecastServiceProtocol.self)!
            let dataAccess = ForecastDataAccess(service: service)
            return dataAccess
            }.inObjectScope(.container)
    }
    
    private func registerScreens(in container: Container) {
        // LaunchScreen
        container.register(LaunchScreenViewModel.self) { r in
            let forecastDataAccess = r.resolve(ForecastDataAccessProtocol.self)!
            return LaunchScreenViewModel(router: self.router,
                                         connectivity: self.connectivity,
                                         forecastDataAccess: forecastDataAccess)
            }.inObjectScope(.weak)
        
        container.register(LaunchScreenViewController.self) { r in
            let vc = StoryboardScene.Main.launchScreenViewController.instantiate()
            let vm = r.resolve(LaunchScreenViewModel.self)!
            vc.viewModel = vm
            return vc
            }.inObjectScope(.weak)
        
        // Home
        container.register(HomeViewModel.self) { r in
            let forecastDataAccess = r.resolve(ForecastDataAccessProtocol.self)!
            return HomeViewModel(router: self.router,
                                     connectivity: self.connectivity,
                                     forecastDataAccess: forecastDataAccess)
            }.inObjectScope(.weak)
        
        container.register(HomeViewController.self) { r in
            let vc = StoryboardScene.Main.homeViewController.instantiate()
            let vm = r.resolve(HomeViewModel.self)!
            vc.viewModel = vm
            return vc
            }.inObjectScope(.weak)
        
        // Detail
        container.register(DetailViewModel.self) { (r, forecastDetails: DailyForecast) in
            return DetailViewModel(router: self.router,
                                       connectivity: self.connectivity,
                                       forecastDetails: forecastDetails)
            }.inObjectScope(.weak)
        
        container.register(DetailViewController.self) { (r, forecastDetails: DailyForecast) in
            let vc = StoryboardScene.Main.detailViewController.instantiate()
            let vm = r.resolve(DetailViewModel.self, argument: forecastDetails)!
            vc.viewModel = vm
            return vc
            }.inObjectScope(.weak)
    }
}

extension AppContainer {
    var connectivity: ConnectivityProtocol {
        return resolve(ConnectivityProtocol.self)!
    }
    
    var router: RouterProtocol {
        return resolve(RouterProtocol.self)!
    }
}

