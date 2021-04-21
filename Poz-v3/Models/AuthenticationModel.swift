import SwiftUI
import LocalAuthentication

struct AuthenticationModel {
    
    @Binding var isUnlocked: Bool
    
    func authenticate() {
        let authenticationContext = LAContext()
        var error: NSError?
        let reasonString = "Enter passcode or touch ID to unlock."

        // Check if the device can evaluate the policy.
        if authenticationContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &error) {

            authenticationContext.evaluatePolicy( .deviceOwnerAuthentication, localizedReason: reasonString, reply: { (success, evalPolicyError) in

                if success {
                    print("success")
                    isUnlocked = true
                } else {
                    // Handle evaluation failure or cancel
                    print("cancelled")
                    isUnlocked = false
                    authenticate()
                }
            })

        } else {
            print("passcode not set")
        }
    }
    
    
    
    func canUseAuthentication() -> Bool {
        let context = LAContext()
        var error: NSError?

        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
}
