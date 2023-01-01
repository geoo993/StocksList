import Foundation

extension APIClient {
    struct Stock {
        let name: String
        let symbol: String
        let logo: String
        let industry: String
    }
}

extension APIClient.Stock: Decodable {
    enum CodingKeys: String, CodingKey {
        case name, logo
        case industry = "finnhubIndustry"
        case symbol = "ticker"
    }
}
 
