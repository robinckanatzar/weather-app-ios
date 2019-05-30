import Foundation
import Swinject

open class DependencyContainer {
    
    private let container: Container
    
    public init(parentContainer: DependencyContainer? = nil) {
        
        self.container = Container(parent: parentContainer?.container)
        registerDependencies(in: container)
    }
    
    open func registerDependencies(in container: Container) {
        fatalError("This method should be override")
    }
    
    // Call to Swinject resolvers
    public func _resolve<Service, Factory>(name: String?, option: ServiceKeyOption? = nil, invoker: (Factory) -> Service) -> Service? {
        return container._resolve(name: name, option: option, invoker: invoker)
    }
    
    public func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        return container.resolve(serviceType)
    }
    
    public func resolve<Service>(_ serviceType: Service.Type, name: String?) -> Service? {
        return container.resolve(serviceType, name: name)
    }
    
    public func resolve<Service, Arg1>(_ serviceType: Service.Type, argument: Arg1) -> Service? {
        return container.resolve(serviceType, argument: argument)
    }
    
    public func resolve<Service, Arg1, Arg2>(
        _ serviceType: Service.Type,
        arguments arg1: Arg1, _ arg2: Arg2) -> Service? {
        return container.resolve(serviceType, arguments: arg1, arg2)
    }
}
