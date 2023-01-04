import SwiftUI

struct WatchlistView: View {
    @StateObject var viewModel: ViewModel
    @State private var query = ""
    private let color = Color(UIColor.systemBackground)
    
    var body: some View {
        ZStack {
            color.edgesIgnoringSafeArea(.all)
            NavigationStack {
                VStack {
                    List {
                        Section {
                            ForEach(viewModel.searches) { value in
                                if value.isSaved {
                                    StockCell(stock: value.stock)
                                } else {
                                    StockSearchCell(stock: value.stock) { stock in
                                        viewModel.add(stock: stock)
                                    }
                                }
                            }
                        }
                        Section {
                            ForEach(viewModel.stocks) {
                                StockCell(stock: $0)
                            }
                            .onDelete(perform: delete)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .navigationTitle("watchlist__screen")
                    .toolbarBackground(color, for: .navigationBar)
                }
            }
            .searchable(text: $query, prompt: "watchlist__search_placeholder")
            .onAppear(perform: loadStocks)
            .onSubmit(of: .search, runSearch)
            .onChange(of: query) { _ in
                runSearch()
            }
        }
    }
    
    func loadStocks() {
        viewModel.loadStocks()
        viewModel.startTimer()
    }
    
    func runSearch() {
        Task {
            await viewModel.search(for: query)
        }
    }
    
    func delete(at offsets: IndexSet) {
        viewModel.deleteStock(at: offsets)
    }
}

struct WatchlistView_Previews: PreviewProvider {
    static var previews: some View {
        WatchlistView(viewModel: .init())
    }
}
