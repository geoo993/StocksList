import Foundation
@testable import StocksList

final class MockAPIClient: APIClientRequestable {
    var executeCalled = false
    var executeRequest: ((_ request: Any) -> Result<Any, APIClient.Error>)?
    
    func execute<T: HTTPRequest, V: Decodable>(
        request: T
    ) async throws -> V where T.ResponseObject == V {
        executeCalled = true
        guard let callback = executeRequest else {
            throw APIClient.Error.unknown
        }
        let result = callback(request)
        switch result {
        case let .success(value as V):
            return value
        case let .failure(error):
            throw error
        default:
            throw APIClient.Error.unknown
        }
    }
}
