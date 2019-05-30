import Foundation
import Marshal

struct City {
    let name: String
}

extension City: Unmarshaling {
    
    init(object: MarshaledObject) throws {
        name = try object.value(for: "name")
    }
}
