import SwiftUI
import Amplify
import AWSCognitoAuthPlugin
import AWSAPIPlugin
import Combine
import AWSDataStorePlugin

// https://docs.amplify.aws/lib/graphqlapi/getting-started/q/platform/ios/#initialize-amplify-api
// https://www.kodeco.com/12931711-using-aws-as-a-back-end-authentication-api?__hstc=149040233.b39ee46afb5b34e8fbddeeaa879c23aa.1670454534881.1671573051385.1672495199995.8&__hssc=149040233.1.1672495199995&__hsfp=2264536231

enum AuthenticationState {
  case signingUp
  case signingIn
  case awaitingConfirmation(String, String)
  case signedIn
  case error(Error)
}

@MainActor
final class AuthenticationViewModel: ObservableObject {
    @Published private(set) var authenticated: Loading<User?> = .idle
    private var cancellables = Set<AnyCancellable>()
    
    func loadAuth() async {
        authenticated = .loading()
        do {
            let smsm = try await fetchUserModel(id: "b9e54c28-6cc9-41ca-8c22-88b4ca51babd")
            print(smsm)
        } catch {
            print(error)
        }
//        await checkAuthSession()
    }
    
    private func signIn(
        username: String,
        password: String
    ) async -> AuthenticationState {
        do {
            let result = try await Amplify.Auth.signIn(username: username, password: password)
            guard result.isSignedIn else {
                throw APIClient.Error.authenticationError
            }
            let authUser = try await Amplify.Auth.getCurrentUser()
            let user = try await fetchUserModel(id: authUser.userId)
            setUser(user)
            return .signedIn
        } catch {
            print(error)
            await signOut()
            return .error(error)
        }
    }
    
    private func signUp(
        username: String,
        password: String,
        email: String
    ) async throws -> AuthenticationState {
        let userAttributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        let result = try await Amplify.Auth.signUp(username: username, password: password, options: options)
        if case .confirmUser = result.nextStep {
            return .awaitingConfirmation(username, password)
        } else {
            throw APIClient.Error.authenticationError
        }
    }
    
    private func confirmSignUp(
        username: String,
        password: String,
        confirmationCode: String
    ) async throws -> AuthenticationState {
        
        do {
            let confirm = try await Amplify.Auth.confirmSignUp(
                for: username,
                confirmationCode: confirmationCode
            )
            guard confirm.isSignUpComplete else {
                throw APIClient.Error.authenticationError
            }
            let result = try await Amplify.Auth.signIn(
                username: username,
                password: password
            )
            let user = try await saveUser(username: username, password: password)
            setUser(user)
            return .signedIn
        } catch {
            print(error)
            await signOut()
            return .error(error)
        }
    }
    
    private func signOut() async {
        setUser(nil)
        _ = await Amplify.Auth.signOut()
    }
    
    private func setUser(_ user: User?) {
        Task {
            if let user {
                self.authenticated = .loaded(user)
            } else {
                self.authenticated = .loaded(nil)
            }
        }
    }
    
    func addUser() {
//        signUp(username: "Geooo", password: "Geocolumb0", email: "ggeoodev@gmail.com")
//            .sink { completion in
//                if case let .failure(error) = completion {
//                    print(error)
//                }
//            } receiveValue: { state in
//                print(state)
//            }
//            .store(in: &cancellables)
    }
    
    func confirmUser() {
//        confirmSignUp(username: "Geooo", password: "Geocolumb0", confirmationCode: "979144")
//            .sink { completion in
//                if case let .failure(error) = completion {
//                    print(error)
//                }
//            } receiveValue: { state in
//                print(state)
//            }
//            .store(in: &cancellables)
    }
    
    private func checkAuthSession() async {
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            print("Is signed in", session.isSignedIn)
            if !session.isSignedIn {
                setUser(nil)
                return
            }
            let authUser = try await Amplify.Auth.getCurrentUser()
            let user = try await fetchUserModel(id: authUser.userId)
            setUser(user)
        } catch {
            print(error)
            await signOut()
        }
    }
    
    private func saveUser(
        username: String,
        password: String
    ) async throws -> User {
        let authUser = try await Amplify.Auth.getCurrentUser()
        let user = User(
          id: authUser.userId,
          username: username,
          password: password,
          createdAt: Temporal.DateTime.now()
        )
        let result = try await Amplify.API.mutate(request: .create(user))
        switch result {
        case .failure(let error):
            throw error
        case .success(let user):
            return user
        }
    }
    
    private func fetchUserModel(id: String) async throws -> User {
        let result = try await Amplify.API.query(request: .get(User.self, byId: id))
        switch result {
        case .failure(let resultError):
            print(resultError.localizedDescription)
            throw resultError
        case .success(let user):
            guard let user = user else {
                let error = APIClient.Error.authenticationError
                print(error.localizedDescription)
                throw error
            }
            return user
        }
    }
}
