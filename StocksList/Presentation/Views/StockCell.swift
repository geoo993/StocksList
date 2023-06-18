import SwiftUI
import GQSwiftCoreSDK

struct StockCell: View {
    let stock: Stock
    
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
            Unwrap(stock.price) { price in
                VStack(alignment: .trailing, spacing: 2) {
                    Text(price.formattedValue)
                        .foregroundColor(Color.primary)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text(price.formattedPercentageChange)
                        .frame(minWidth: 60, alignment: .trailing)
                        .padding(6)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .background(price.percentageChangeColor)
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }
            }
        }
    }
}

struct StockCell_Previews: PreviewProvider {
    static var previews: some View {
        StockCell(stock: .fixture())
    }
}
