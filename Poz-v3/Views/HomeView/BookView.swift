//
//  BookView.swift
//  Poz-v3
//
//  Created by Kish Parikh on 3/25/21.
//

import SwiftUI

struct BookView: View {
    
    @ObservedObject var settings: SettingsModel
    
    @Environment(\.colorScheme) var colorScheme
    @Binding var tabIndex: Int
    
    //to get last date
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Note.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Note.lastUpdated, ascending: false)]) var notes: FetchedResults<Note>
    
    @State var date = Date()
    @State var dateFormatter = DateFormatter();
    @State var dateString: String = ""
    
    @Binding var isOpening: Bool
    
    @State var customizeJournal = false
    
    @State var bookPatterns = bookPatternsList()
    
    @Binding var promptSelectedIndex: Int
    
    var body: some View {
        VStack {
            VStack {
                
                //book
                Button( action: {
                    withAnimation(.spring()) {
                        isOpening = true
                    
                        openBook()
                    }
                }) {
                    ZStack {
                        Image("book").resizable()
                            .frame(width: UIScreen.main.bounds.width/2, height: (UIScreen.main.bounds.width/2)*1.4)
                            .shadow(color: (colorScheme == .dark ? Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6)) : Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))), radius: 5, x: 0.0, y: 10)
                            .shadow(color: (colorScheme == .dark ? Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6)) : Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))), radius: 20, x: 0.0, y: 15)
                            .hueRotation(Angle(degrees: settings.journalColorAngle))
                     
                        Image(bookPatterns.bookPatterns[settings.journalPatternIndex].patternImageString)
                            .resizable(resizingMode: .tile)
                            .frame(width: UIScreen.main.bounds.width/2, height: (UIScreen.main.bounds.width/2)*1.4)
                            .colorInvert()
                            .opacity(0.08)
                            .animation(.easeOut)
                        
                        VStack {
                            Text(settings.journalName)
                                .font(Font.custom("Blueberry Regular", size: (UIScreen.main.bounds.width/2)/9))
                                .foregroundColor(Color(.white))
                            Text(settings.journalEmoji)
                                .font(Font.custom("Blueberry Regular", size: (UIScreen.main.bounds.width/2)/3.3))
                                .foregroundColor(Color(.white))
                        }
                        
                        // Small chart
                        
//                        if settings.goalNumber > 0 {
//                            smallGoalView(settings: settings)
//                                .offset(x: (UIScreen.main.bounds.width/2)/3.3, y: (UIScreen.main.bounds.width/2)/2)
//                        }
                     
                    }
                    .padding(.bottom, 10)
                    .scaleEffect(isOpening ? 1.75 : 1)
                    .onAppear() {
                        dateFormatter.dateFormat = "MM/dd/yy"
                        dateString = dateFormatter.string(from: (notes[0].lastUpdated ?? Date()) as Date)
                    }
                }
                
                if (!isOpening) {
                        //book details and edit button
                        HStack (spacing: 0) {
                            
                            if (dateString != "12/31/00") {
                                Text("Last updated: ")
                                    .font(Font.custom("Poppins-Light", size:
                                                        (UIScreen.main.bounds.width > 420 ? ((UIScreen.main.bounds.width/2)/18) : ((UIScreen.main.bounds.width/2)/12))))
                                    .foregroundColor(Color(UIColor(named: "PozGray")!))
                                
                                    Text(dateString)
                                        .font(Font.custom("Poppins-Medium", size:
                            (UIScreen.main.bounds.width > 420 ? ((UIScreen.main.bounds.width/2)/18) : ((UIScreen.main.bounds.width/2)/12))))
                            
                            } else {
                                Text("Add your first entry")
                                    .font(Font.custom("Poppins-Light", size:
                                                        (UIScreen.main.bounds.width > 420 ? ((UIScreen.main.bounds.width/2)/18) : ((UIScreen.main.bounds.width/2)/12))))
                                    .foregroundColor(Color(UIColor(named: "PozGray")!))
                            }
                        
                        Button( action: {
                            withAnimation(.spring()) {
                                isOpening = true
                                openBook()
                            }
                        } ) {
                            Text("✏️")
                                .font(Font.custom("Poppins-Medium", size: (UIScreen.main.bounds.width > 420 ? ((UIScreen.main.bounds.width/2)/18) : ((UIScreen.main.bounds.width/2)/12))))
                                .foregroundColor(Color(UIColor(named: "PozGray")!))
                                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                        }
                        .padding(.leading, 14)
                        .sheet(isPresented: $customizeJournal, content: {
                            CustomizeJournalView(settings: settings).environment(\.managedObjectContext, self.moc)
                        })
                    }
                    .padding(.bottom, 85)
                }
            }
           
        }
        .frame(width: UIScreen.main.bounds.width)
    }
    
    func openBook() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.15) {
            withAnimation () {
                tabIndex = 1
            }
        }
    }
}

struct BookStaticView: View {
    
    @ObservedObject var settings: SettingsModel
    @Environment(\.colorScheme) var colorScheme
    
    @State var bookPatterns = bookPatternsList()
    
    @State var tempBookPattern = "blank"
    
    @Binding var bookPatternIndex: Int
    
    //to get last date
    @FetchRequest(entity: Note.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Note.createdAt, ascending: false)]) var notes: FetchedResults<Note>
    
    var body: some View {
        ZStack {
            Image("book").resizable()
                .frame(width: 180, height: 250)
                .shadow(color: (colorScheme == .dark ? Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6)) : Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))), radius: 5, x: 0.0, y: 10)
                .shadow(color: (colorScheme == .dark ? Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6)) : Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))), radius: 20, x: 0.0, y: 15)
                .hueRotation(Angle(degrees: settings.journalColorAngle))
            
            Image(bookPatterns.bookPatterns[bookPatternIndex].patternImageString)
                .resizable(resizingMode: .tile)
                .frame(width: 175, height: 250)
                .colorInvert()
                .opacity(0.08)
            
            VStack {
                Text(settings.journalName)
                    .font(Font.custom("Blueberry Regular", size: 20))
                    .foregroundColor(Color(.white))
                
                Text(settings.journalEmoji)
                    .font(Font.custom("Blueberry Regular", size: 52))
                    .foregroundColor(Color(.white))
            }
        }
    }
}
