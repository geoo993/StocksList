struct Price {
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
}
