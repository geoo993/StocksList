import Foundation

struct APIClient: APIClientRequestable {
    private let session: HTTPSession

    init(session: HTTPSession = URLSession.shared) {
        self.session = session
    }
    
    func execute<T: HTTPRequest, V: Decodable>(
        request: T
    ) async throws -> V where T.ResponseObject == V {
        let urlRequest = try urlRequest(from: request)
        let result = try await session.data(of: urlRequest)
        return try process(result)
    }
    
    private func urlRequest<T: HTTPRequest>(from endPoint: T) throws -> URLRequest {
        let url = try urlComponent(from: endPoint)
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        request.timeoutInterval = endPoint.timeoutInterval
        setHeaders(with: endPoint.headers, request: &request)
        return request
    }
    
    private func urlComponent<T: HTTPRequest>(from endPoint: T) throws -> URL {
        guard
            let url = endPoint.baseUrl,
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else {
            throw Error.invalidUrl
        }
        urlComponents.path = endPoint.path
        urlComponents.queryItems = endPoint.queryItems
        guard let url = urlComponents.url else { throw Error.invalidUrlComponent }
        return url
    }
    
    private func setHeaders(with headers: HTTPHeaders?, request: inout URLRequest) {
        var values = ["Content-Type": "application/json"]
        if let httpHeaders = headers { values.merge(httpHeaders) { $1 } }
        for (key, value) in values {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    private func process<T: Decodable>(
        _ result: HTTPSession.DataOutput
    ) throws -> T {
        let response = result.response as? HTTPURLResponse
        switch (result.data, response) {
        case let (data, .some(value)) where HTTPCodes.success ~= value.statusCode:
            return try JSONDecoder().decode(T.self, from: data)
        case let (_, .some(value)):
            throw error(for: value.statusCode)
        default:
            throw Error.noResponse
        }
    }

    private func error(
        for code: HTTPCode
    ) -> Error {
        switch code {
        case HTTPCodes.authError: return .authenticationError
        case HTTPCodes.badResponse: return .responseError(code)
        case HTTPCodes.outdated: return .outdatedRequest
        default: return .unknown
        }
    }
}
