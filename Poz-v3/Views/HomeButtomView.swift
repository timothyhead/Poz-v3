//
//  HomeButtomView.swift
//  Poz-v3
//
//  Created by Kish Parikh on 3/24/21.
//

import SwiftUI

struct HomeButtomView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Binding var tabIndex: Int
    
    var body: some View {
        Button(action: {self.tabIndex = 0}) {
            Image(systemName: (self.tabIndex == 0 ? "house.fill" : "house")).resizable()
            .frame(width: 25, height: 25)
            .opacity((self.tabIndex == 0 ? 1 : 0.3))
            .foregroundColor(colorScheme == .dark ? Color(#colorLiteral(red: 0.9254901961, green: 0.9294117647, blue: 0.9333333333, alpha: 1)) : Color(#colorLiteral(red: 0.1514667571, green: 0.158391118, blue: 0.1616251171, alpha: 1)))
        }
    }
}
