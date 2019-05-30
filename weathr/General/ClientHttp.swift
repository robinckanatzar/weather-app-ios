import Foundation
import Alamofire
import Marshal

class ClientHTTP: ClientHTTPProtocol {
    
    // MARK: - Constant
    private enum Constant {
        static let preprodBaseURL = "http://api.openweathermap.org/data/2.5/"
        static let baseURL = "http://api.openweathermap.org/data/2.5/"
    }
    
    private func fullURL(with path: String) -> URL {
        #if PREPROD
        let baseURL = Constant.preprodBaseURL
        #else
        let baseURL = Constant.baseURL
        #endif
        
        guard let url = URL(string: baseURL+path) else {
            fatalError("\(baseURL+path) is not a valid URL")
        }
        return url
    }
    
    private func makeCall(on path: String, httpMethod: HTTPMethod, parameters: Parameters?,
                          encoding: ParameterEncoding?, headers: HTTPHeaders?, completionHandler: @escaping (DataResponse<Any>) -> Void) {
        let url = fullURL(with: path)
        var finalEncoding: ParameterEncoding = URLEncoding.default
        if let encoding = encoding {
            finalEncoding = encoding
        }
        
        Alamofire.request(url, method: httpMethod, parameters: parameters, encoding: finalEncoding, headers: headers).responseJSON { (response) in
            completionHandler(response)
        }
    }
    
    func makeRequest(on path: String, httpMethod: HTTPMethod, parameters: Parameters?,
                     encoding: ParameterEncoding?, headers: HTTPHeaders?, completion: @escaping (ServiceResult<Bool>) -> Void) {
        makeCall(on: path, httpMethod: httpMethod, parameters: parameters, encoding: encoding, headers: headers) { (response) in
            let statusCode = response.response?.statusCode ?? 200
            let statusCodeIsSuccessful = [200,201].contains(statusCode)
            completion(ServiceResult.success(value: response.result.isSuccess && statusCodeIsSuccessful))
        }
    }
    
    func makeRequest<Result: Unmarshaling>(on path: String, httpMethod: HTTPMethod, parameters: Parameters?,
                                           encoding: ParameterEncoding?, headers: HTTPHeaders?,
                                           completion: @escaping (ServiceResult<Result>) -> Void) {
        
        makeCall(on: path, httpMethod: httpMethod, parameters: parameters, encoding: encoding, headers: headers) { (response) in
            
            if response.result.isSuccess, let value = response.result.value as? MarshaledObject {
                do {
                    let item = try Result.init(object: value)
                    completion(ServiceResult.success(value: item))
                } catch {
                    completion(ServiceResult.failure(error:
                        ServiceError.deserializationError(message: "Deserialization Error with type : \(Result.self)")))
                }
            } else {
                completion(ServiceResult.failure(error: ServiceError.technicalError))
            }
        }
    }
    
    func makeRequest<Result: Unmarshaling>(on path: String, httpMethod: HTTPMethod, parameters: Parameters?,
                                           encoding: ParameterEncoding?, headers: HTTPHeaders?,
                                           completion: @escaping (ServiceResult<[Result]>) -> Void) {
        
        makeCall(on: path, httpMethod: httpMethod, parameters: parameters, encoding: encoding, headers: headers) { (response) in
            
            if response.result.isSuccess {
                
                guard response.result.value is [Any],
                    let data = response.data else {
                        completion(ServiceResult.failure(error:
                            ServiceError.deserializationError(message: "Try to deserialize array but the API response is not of type Array")))
                        return
                }
                
                do {
                    let items = try JSONParser.JSONArrayWithData(data).map(Result.init)
                    completion(ServiceResult.success(value: items))
                } catch {
                    completion(ServiceResult.failure(error:
                        ServiceError.deserializationError(message: "Deserialization Error of a collection of type : \(Result.self)")))
                }
            } else {
                completion(ServiceResult.failure(error: ServiceError.technicalError))
            }
        }
    }
    
    func upload<Result: Unmarshaling>(on path: String, httpMethod: HTTPMethod, imageDataDict: [String: Data?], parameters: Parameters?, encoding: ParameterEncoding?, headers: HTTPHeaders?, completion: @escaping (ServiceResult<Result>) -> Void) {
        
        let url = fullURL(with: path)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if let dataDict = imageDataDict.first,
                let imageData = dataDict.value {
                let name = dataDict.key
                multipartFormData.append(imageData, withName: name, fileName: "picture_name.jpg", mimeType: "image/jpeg")
            }
            
            if let parameters = parameters {
                for (key, value) in parameters {
                    if let valueData = "\(value)".data(using: String.Encoding.utf8) {
                        multipartFormData.append(valueData, withName: key)
                    }
                }
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: httpMethod, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if response.result.isSuccess, let value = response.result.value as? MarshaledObject {
                        do {
                            let item = try Result.init(object: value)
                            completion(ServiceResult.success(value: item))
                        } catch {
                            completion(ServiceResult.failure(error:
                                ServiceError.deserializationError(message: "Deserialization Error with type : \(Result.self)")))
                        }
                    } else {
                        completion(ServiceResult.failure(error: ServiceError.technicalError))
                    }
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                completion(ServiceResult.failure(error: ServiceError.technicalError))
            }
        }
    }
}

