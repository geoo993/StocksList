import SwiftUI

struct AuthenticationView: View {
    @StateObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        ZStack {
            Color.red.edgesIgnoringSafeArea(.all)
            VStack {
                switch viewModel.authenticated {
                case .idle, .loading:
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                case .error(let error):
                    ErrorView(error: error, retryAction: {})
                case let .loaded(authenticated) where authenticated != nil:
                    WatchlistView(viewModel: .init())
                case .loaded:
                    VStack {
                        Button("Add user") {
                            viewModel.addUser()
                        }
                        Button("Confirm user") {
                            viewModel.confirmUser()
                        }
                        Button("Signout") {
                            viewModel.confirmUser()
                        }
                    }
                }
            }
        }
        .task {
            await viewModel.loadAuth()
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView(viewModel: .init())
    }
}
