import Foundation
import Marshal

struct Temperature {
    let min: Double
    let max: Double
}

extension Temperature: Unmarshaling {
    
    init(object: MarshaledObject) throws {
        min = try object.value(for: "min")
        max = try object.value(for: "max")
    }
}
