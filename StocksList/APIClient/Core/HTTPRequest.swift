import Foundation

typealias HTTPHeaders = [String: String]

protocol HTTPRequest {
    associatedtype ResponseObject = Any
    associatedtype ErrorObject = Error
    var provider: APIClient.Provider { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var queryItems: [URLQueryItem]? { get }
    var timeoutInterval: TimeInterval { get }
}

extension HTTPRequest {
    var baseUrl: URL? { provider.baseUrl }
    var method: HTTPMethod { .get }
    var queryItems: [URLQueryItem]? { nil }
    var timeoutInterval: TimeInterval { 30.0 }
}
