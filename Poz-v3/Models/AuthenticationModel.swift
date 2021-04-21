import SwiftUI
import LocalAuthentication

struct AuthenticationModel {
    
    @Binding var isUnlocked: Bool
    
    func authenticateDo() {
        let authenticationContext = LAContext()
        var error: NSError?
        let reasonString = "Enter passcode or touch ID to unlock."

        // Check if the device can evaluate the policy.
        if authenticationContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &error) {

            authenticationContext.evaluatePolicy( .deviceOwnerAuthentication, localizedReason: reasonString, reply: { (success, evalPolicyError) in

                if success {
                    print("success")
                    isUnlocked = true
                    
                    UserDefaults.standard.set(true, forKey: "useAuthentication")
                    
                } else {
                    // Handle evaluation failure or cancel
                    print("cancelled")
                    isUnlocked = false
                    
                    UserDefaults.standard.set(false, forKey: "useAuthentication")
//                    authenticate()
                    
                }
                
            })

        } else {
            isUnlocked = true
        }
        
//        return isUnlocked
        
    }
    
    func authenticate() -> Bool {
        let authenticationContext = LAContext()
        var error: NSError?
        let reasonString = "Enter passcode or touch ID to unlock."

        // Check if the device can evaluate the policy.
        if authenticationContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &error) {

            authenticationContext.evaluatePolicy( .deviceOwnerAuthentication, localizedReason: reasonString, reply: { (success, evalPolicyError) in

                if success {
                    print("success")
                    isUnlocked = true
                    
                    UserDefaults.standard.set(true, forKey: "useAuthentication")
                    
                } else {
                    // Handle evaluation failure or cancel
                    print("cancelled")
                    isUnlocked = false
                    
                    UserDefaults.standard.set(false, forKey: "useAuthentication")
//                    authenticate()
                    
                }
                
            })

        } else {
            isUnlocked = true
        }
        
        return isUnlocked
        
    }
    
    func canUseAuthentication() -> Bool {
        let authenticationContext = LAContext()
        var error: NSError?
        
        return authenticationContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &error)
    }
}
