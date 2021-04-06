//
//  UserSettingsView.swift
//  Poz-v3
//
//  Created by Kish Parikh on 3/28/21.
//

import SwiftUI

struct UserSettingsView: View {
    
    @ObservedObject var settings: SettingsModel
    
    @State var isEditing = false
    
    var body: some View {
        Form {
            
            TextField("\(settings.username)", text: $settings.username) { isEditing in
                self.isEditing = isEditing
                UserDefaults.standard.set(settings.username, forKey: "Username")
            }
            
        }.navigationTitle("Edit Name").background(Color.black)
    }
}
