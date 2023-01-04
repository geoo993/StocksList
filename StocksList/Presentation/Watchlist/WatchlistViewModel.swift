import SwiftUI

@MainActor
final class ViewModel: ObservableObject {
    @Published var stocks = [Stock]()
    @Published var searches = [StockSearch]()
    private let interactor: WatchlistInteractor
    private var timer: Timer?
    
    init(interactor: WatchlistInteractor = DefaultWatchlistInteractor()) {
        self.interactor = interactor
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: 10,
            target: self,
            selector: #selector(refreshStocksQuote),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc private func refreshStocksQuote() {
        var list = stocks
        for (index, item) in list.enumerated() {
            Task {
                let price = try await interactor.price(for: item)
                list[index] = Stock(
                    name: item.name,
                    symbol: item.symbol,
                    logo: item.logo,
                    price: price
                )
                stocks = list
            }
        }
    }
    
    func loadStocks() {
        do {
            stocks = try interactor.savedStocks()
            refreshStocksQuote()
        } catch {}
    }
    
    func search(for query: String) async {
        do {
            searches = try await interactor.search(query: query)
        } catch {
            searches = []
        }
    }

    func add(stock: Stock) {
        do {
            try interactor.save(stock: stock)
            searches = try interactor.refreshSearch(of: stock)
            stocks.append(stock)
        } catch {}
    }
    
    func deleteStock(at offsets: IndexSet) {
        guard
            let index = Array(offsets).first,
            let stock = stocks[safe:index]
        else { return }
        do {
            try interactor.delete(stock: stock)
            stocks.remove(atOffsets: offsets)
        } catch {}
    }
}
