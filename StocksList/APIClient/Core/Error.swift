import Foundation

extension APIClient {
    enum Error: Swift.Error, Equatable {
        case unknown
        case invalidUrl
        case invalidUrlComponent
        case noResponse
        case authenticationError
        case responseError(HTTPCode)
        case outdatedRequest
    
        public var localizedDescription: String {
            switch self {
            case .unknown: return "Unknown"
            case .authenticationError: return "You need to be authenticated"
            case .invalidUrl: return "We encounted an error using url"
            case .invalidUrlComponent: return "We encountered an error with url component"
            case .outdatedRequest: return "The url you requested is outdated"
            case .noResponse: return "Did not get a HTTPURLResponse"
            case .responseError(let statusCode): return "We had an error with response with status code \(statusCode)"
            }
        }
    }
}

extension APIClient.Error {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.unknown, .unknown),
            (.authenticationError, .authenticationError),
            (.invalidUrl, .invalidUrl),
            (.invalidUrlComponent, .invalidUrlComponent),
            (.outdatedRequest, .outdatedRequest),
            (.noResponse, .noResponse):
            return true
        case (.responseError(let left), .responseError(let right)):
            return left == right
        default:
            return false
        }
    }
}
