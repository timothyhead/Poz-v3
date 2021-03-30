//
//  BookPatternModel.swift
//  Poz-v3
//
//  Created by Kish Parikh on 3/29/21.
//

import SwiftUI

struct bookPattern : Hashable {
    
    let patternImageString : String
    let bookPatternName : String
    let bookPatternIndex : Int
}

class bookPatternsList : ObservableObject {
    
    @State var bookPatterns: [bookPattern] = [
        bookPattern(patternImageString: "blank", bookPatternName: "None", bookPatternIndex: 0),
        bookPattern(patternImageString: "bubbles", bookPatternName: "Bubbles", bookPatternIndex: 1),
        bookPattern(patternImageString: "circuit-board", bookPatternName: "Circuit", bookPatternIndex: 2),
        bookPattern(patternImageString: "dominos", bookPatternName: "Dominos", bookPatternIndex: 3),
        bookPattern(patternImageString: "falling-triangles", bookPatternName: "Triangles", bookPatternIndex: 4),
        bookPattern(patternImageString: "yyy", bookPatternName: "YYY", bookPatternIndex: 5),
        bookPattern(patternImageString: "jupiter", bookPatternName: "Jupiter", bookPatternIndex: 6),
        bookPattern(patternImageString: "overlapping-circles", bookPatternName: "Cicles", bookPatternIndex: 7),
    ]
}
