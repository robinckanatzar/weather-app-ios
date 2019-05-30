import Foundation

enum ServiceError: Error {
    case noNetwork
    case serviceError(code: Int, message: String)
    case deserializationError(message: String)
    case technicalError
}

enum ServiceResult<T> {
    case success(value: T)
    case failure(error: ServiceError)
}

typealias ServiceResultCompletion<T> = (ServiceResult<T>) -> Void
