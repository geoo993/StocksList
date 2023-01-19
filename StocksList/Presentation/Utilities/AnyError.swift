import Foundation

struct AnyError: Error, Equatable {
    let wrappedError: Error

    init<E: Error>(_ wrappedError: E) {
        self.wrappedError = wrappedError
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        (lhs.wrappedError as NSError) == (rhs.wrappedError as NSError)
    }
}

struct AnyLocalizedError: LocalizedError, Hashable {
    let wrappedError: LocalizedError

    init<E: LocalizedError>(_ wrappedError: E) {
        self.wrappedError = wrappedError
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        (lhs.wrappedError as NSError) == (rhs.wrappedError as NSError)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedError as NSError)
    }
}
