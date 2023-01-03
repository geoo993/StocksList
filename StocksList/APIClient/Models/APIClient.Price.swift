import Foundation

extension APIClient {
    struct Price {
        let value: Double
        let percentageChange: Double
    }
}

extension APIClient.Price: Decodable {
    enum CodingKeys: String, CodingKey {
        case value = "c"
        case percentageChange = "dp"
    }
}
