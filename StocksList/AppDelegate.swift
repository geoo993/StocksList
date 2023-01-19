import Amplify
import AWSAPIPlugin
import AWSCognitoAuthPlugin
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSAPIPlugin(modelRegistration: AmplifyModels()))
            try Amplify.configure()
            
#if DEBUG
            Amplify.Logging.logLevel = .debug
#else
            Amplify.Logging.logLevel = .error
#endif
            print("Amplify configured with API plugin")
        } catch {
            print("Error initializing Amplify. \(error)")
        }

        return true
    }
}
