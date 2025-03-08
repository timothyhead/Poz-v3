//
//  EntryView.swift
//  PozExtension
//
//  Created by Kish Parikh on 3/29/21.
//

import SwiftUI

struct EntryView: View {
    let model: WidgetContent

    var body: some View {
      VStack(alignment: .leading) {
        Text(model.name)
//          .font(.uiTitle4)
          .lineLimit(2)
          .fixedSize(horizontal: false, vertical: true)
          .padding([.trailing], 15)
        
        Text(model.cardViewSubtitle)
          .lineLimit(nil)
        
        Text(model.descriptionPlainText)
//          .font(.uiCaption)
          .fixedSize(horizontal: false, vertical: true)
          .lineLimit(2)
          .lineSpacing(3)
        
        Text(model.releasedAtDateTimeString)
//          .font(.uiCaption)
          .lineLimit(1)
      }
      .padding()
      .cornerRadius(6)
    }
}
