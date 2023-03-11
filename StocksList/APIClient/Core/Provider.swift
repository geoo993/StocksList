import Foundation

extension APIClient {
    enum Provider {
        case finnhub, marketaux
    }
}

extension APIClient.Provider {
    var baseUrl: URL? {
        switch self {
        case .finnhub:
            return URL(string: "https://finnhub.io")
        case .marketaux:
            return URL(string: "https://api.marketaux.com")
        }
    }
    
    var apiToken: String {
        switch self {
        case .finnhub:
            return "bs8u7q7rh5re5dkf6kig"
        case .marketaux:
            return "w43sj7tt6QU68bJmdXyvpgPSpQR3PijnlkxeGJc9"
        }
    }
}
