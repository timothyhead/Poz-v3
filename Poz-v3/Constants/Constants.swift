
//
//  Constants.swift
//  Poz-v3
//
//  Created by Timothy Head on 28/02/2025.
//

import Foundation


// used to carry the message and the id of the note on the current page into the parent view where the ModelPages struct is
struct Constants {
    static let shared = Constants()
    let messageId: String = "messageId"

    let pageTurned: String = "pageTurned"
    let lastIndex: String = "lastIndex"
}

