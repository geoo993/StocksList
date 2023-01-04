import SwiftUI

struct StockSearchCell: View {
    let stock: Stock
    let action: (Stock) -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(stock.symbol)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Color.primary)
                Text(stock.name)
                    .font(.subheadline)
                    .foregroundColor(Color.secondary)
            }
            Spacer()
            Button {
                action(stock)
            } label: {
                Text("watchlist__search_add_cta")
                    .foregroundColor(Color(UIColor.systemBlue))
            }
        }
    }
}

struct StockSearchCell_Previews: PreviewProvider {
    static var previews: some View {
        StockSearchCell(stock: .fixture()) { _ in }
    }
}
