// swiftlint:disable:next superfluous_disable_command
// swiftlint:disable force_unwrapping
// https://www.kodeco.com/10886648-graphql-using-the-apollo-framework-getting-started

import Foundation
import Apollo

class Apollo {
  // 1
  static let shared = Apollo()
  // 2
  let client: ApolloClient
  // 3
  init() {
    // swiftlint:disable:next force_unwrapping
    client = ApolloClient(url: URL(string: "http://localhost:58410")!)
  }
}
