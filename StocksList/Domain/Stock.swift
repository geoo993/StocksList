import Foundation

struct Stock {
    let name: String
    let symbol: String
    let logo: URL?
    let industry: String
}

extension Stock {
    init(model: APIClient.Stock) {
        self.init(
            name: model.name,
            symbol: model.symbol,
            logo: URL(string: model.logo),
            industry: model.industry
        )
    }
}
