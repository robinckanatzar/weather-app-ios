import Foundation
import Alamofire

protocol ConnectivityProtocol {
    var isConnected: Observable<Bool> { get }
}

enum ConnectivityError: Error {
    case networkReachabilityManagerInitError
}

struct NetworkListener {
    let statusDidChange: Listener
    let id: String
}

typealias Listener = (Bool) -> Void

class Connectivity: ConnectivityProtocol {
    
    private let manager: NetworkReachabilityManager?
    let isConnected = Observable<Bool>()
    
    init() {
        manager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
        if manager == nil {
            print("Error : NetworkReachabilityManager is nil")
        }
        isConnected.value = manager?.isReachable
        manager?.startListening()
        manager?.listener = callBack
    }
    
    private func callBack(_: NetworkReachabilityManager.NetworkReachabilityStatus) {
        isConnected.value = manager?.isReachable
    }
}
