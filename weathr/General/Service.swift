import Foundation

class Service {
    
    // MARK: - Dependencies
    let clientHTTP: ClientHTTPProtocol
    
    // MARK: - Var
    var path: String {
        get {
            return ""
        }
    }
    
    // MARK: - Lifecycle
    init(clientHTTP: ClientHTTPProtocol) {
        self.clientHTTP = clientHTTP
    }
}
