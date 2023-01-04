struct StockSearch: Equatable {
    let stock: Stock
    let isSaved: Bool
}

extension StockSearch: Identifiable {
    var id: String { stock.symbol }
}
