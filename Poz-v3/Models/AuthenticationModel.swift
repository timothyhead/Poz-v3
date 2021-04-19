//
//  AuthenticationModel.swift
//  Poz-v3
//
//  Created by Kish Parikh on 3/30/21.
//

import SwiftUI
import LocalAuthentication

struct AuthenticationModel {
    
    @Binding var isUnlocked: Bool
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your journal"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in

                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                    } else {
                        authenticate()
                    }
                }

            }
        } else {
            self.isUnlocked = true
        }
    }
    
    func canUseAuthentication() -> Bool {
        let context = LAContext()
        var error: NSError?

        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
}
