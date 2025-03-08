import SwiftUI
import LocalAuthentication

struct AuthenticationModel {
    
    @Binding var isUnlocked: Bool
    
    //void function that sets isUnlocked
    func authenticateDo() {
        let authenticationContext = LAContext()
        var error: NSError?
        let reasonString = "Enter passcode or touch ID to unlock."

        // Check if the device can authenticat
        if authenticationContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &error) {

            //authenticate
            authenticationContext.evaluatePolicy( .deviceOwnerAuthentication, localizedReason: reasonString, reply: { (success, evalPolicyError) in

                if success {
                    print("success")
                    isUnlocked = true
                    
                    // set userDefault to true for authentication
                    UserDefaults.standard.set(true, forKey: "useAuthentication")
                    
                } else {
                    print("cancelled")
                    isUnlocked = false
                }
            })
        } else {
            
            // if no authentication methods exist
            isUnlocked = true
        }
        
    }
    
    //void function that returns vool
    func authenticate() -> Bool {
        let authenticationContext = LAContext()
        var error: NSError?
        let reasonString = "Enter passcode or touch ID to unlock."

        // Check if the device can authenticate
        if authenticationContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &error) {

            //authenticate
            authenticationContext.evaluatePolicy( .deviceOwnerAuthentication, localizedReason: reasonString, reply: { (success, evalPolicyError) in

                if success {
                    print("success")
                    isUnlocked = true
                    
                    // set userDefault to true for authentication
                    UserDefaults.standard.set(true, forKey: "useAuthentication")
                    
                } else {
                    print("cancelled")
                    isUnlocked = false
                    
                    // set userDefault to false for authentication
                    UserDefaults.standard.set(false, forKey: "useAuthentication")
                }
            })

        } else {
            
            // if no authentication methods exist
            isUnlocked = true
        }
        
        return isUnlocked
        
    }
    
    //check whether user's device support authentication
    func canUseAuthentication() -> Bool {
        let authenticationContext = LAContext()
        var error: NSError?
        
        return authenticationContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &error)
    }
}
