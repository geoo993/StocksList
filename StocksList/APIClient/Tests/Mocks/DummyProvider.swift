import Foundation
@testable import StocksList

protocol DummyProviding {
    static func dummy() -> Data
}

extension DummyProviding {
    static func dummy() -> Data {
        let url = Bundle.main.url(forResource: String(describing: self), withExtension: "json")!
        return try! Data(contentsOf: url)
    }
}

extension FetchStockQuoteRequest: DummyProviding {}
extension FetchStockRequest: DummyProviding {}
