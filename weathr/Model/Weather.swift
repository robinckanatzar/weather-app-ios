import Foundation
import Marshal

struct Weather {
    let icon: String
}

extension Weather: Unmarshaling {
    
    init(object: MarshaledObject) throws {
        icon = try object.value(for: "icon")
    }
}
