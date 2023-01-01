import Foundation
@testable import StocksList

final class MockHTTPSession: HTTPSession {
    private var stub: Stub?
    
    func register(stub: Stub) {
        self.stub = stub
    }
    
    func data(of urlRequest: URLRequest) async throws -> DataOutput {
        let stub = try self.registeredStub(for: urlRequest)
        guard let url = urlRequest.url else { throw APIClient.Error.invalidUrl }
        guard let response = HTTPURLResponse(
            url: url,
            statusCode: stub.statusCode,
            httpVersion: "HTTP/1.1",
            headerFields: nil
        ) else { throw APIClient.Error.noResponse }
        return (stub.data, response)
    }

    private func registeredStub(for request: URLRequest) throws -> Stub {
        guard
            let stub = self.stub,
            let path = request.url?.path,
            request.httpMethod == stub.method.rawValue,
            path == stub.path
        else { throw URLError(.dataNotAllowed) }
        return stub
    }
}

extension MockHTTPSession {
    struct Stub {
        let path: String
        let method: HTTPMethod
        let statusCode: APIClient.HTTPCode
        let data: Data

        init(
            path: String,
            method: HTTPMethod,
            statusCode: APIClient.HTTPCode,
            data: Data = Data()
        ) {
            self.path = path
            self.method = method
            self.statusCode = statusCode
            self.data = data
        }
    }
}
