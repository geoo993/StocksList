import SwiftUI

struct Price: Equatable {
    let value: Double
    let percentageChange: Double
}

extension Price {
    init(model: APIClient.Price) {
        self.init(
            value: model.value,
            percentageChange: model.percentageChange
        )
    }
    
    var formattedValue: String {
        String(format: "%.2f", value)
    }
    
    var formattedPercentageChange: String {
        String(format: "%@%.2f", percentageChange > 0 ? "+" : "", percentageChange)
    }
    
    var percentageChangeColor: Color {
        if percentageChange > 0 {
            return .green
        } else if percentageChange < 0 {
            return .red
        } else {
            return .gray
        }
    }
}
