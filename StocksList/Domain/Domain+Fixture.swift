import Foundation

extension Stock {
    static func fixture(
        name: String = "Apple",
        symbol: String = "AAPL",
        logo: URL? = URL(string: "https://static2.finnhub.io/file/publicdatany/finnhubimage/stock_logo/AAPL.svg"),
        price: Price? = .fixture()
    ) -> Self {
        self.init(
            name: name,
            symbol: symbol,
            logo: logo,
            price: price
        )
    }
}

extension Price {
    static func fixture(
        price: Double = 183.23,
        percentageChange: Double = 0.23
    ) -> Self {
        self.init(value: price, percentageChange: percentageChange)
    }
}
