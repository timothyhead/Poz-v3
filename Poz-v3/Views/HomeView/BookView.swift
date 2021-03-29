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
    @FetchRequest(entity: Note.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Note.createdAt, ascending: false)]) var notes: FetchedResults<Note>
    
    @State var date = Date()
    @State var dateFormatter = DateFormatter();
    @State var dateString: String = ""
    
    @Binding var isOpening: Bool
    
    @State var customizeJournal = false
    
    var body: some View {
        VStack {
            VStack {
                
                //book
                Button( action: {
                    withAnimation(.spring()) {
                        isOpening = true
                    
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.15) {
                            withAnimation () {
                                tabIndex = 1
                            }
                        }
                    }
                }) {
                    ZStack {
                        Image("book").resizable()
                            .frame(width: 180, height: 250)
                            .shadow(color: (colorScheme == .dark ? Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6)) : Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))), radius: 5, x: 0.0, y: 10)
                            .shadow(color: (colorScheme == .dark ? Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6)) : Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))), radius: 20, x: 0.0, y: 15)
                            .hueRotation(Angle(degrees: settings.journalColorAngle))
                        
                        VStack {
                            Text(settings.journalName)
                                .font(Font.custom("Blueberry Regular", size: 20))
                                .foregroundColor(Color(.white))
                            Text(settings.journalEmoji)
                                .font(Font.custom("Blueberry Regular", size: 52))
                                .foregroundColor(Color(.white))
                        }
                        
                        // Small chart
                        smallGoalView(settings: settings)
                            .offset(x: -50, y: 80)
                     
                    }
                    .padding(.bottom, 10)
                    .scaleEffect(isOpening ? 1.75 : 1)
                    
                }
                
                if !isOpening {
                    //book details and edit button
                    HStack (spacing: 0) {
                        Text("Last updated: ")
                            .font(Font.custom("Poppins-Light", size: 16))
                            .foregroundColor(Color(UIColor(named: "PozGray")!))
                        
                            Text(dateString)
                                .font(Font.custom("Poppins-Medium", size: 16))
                                .onAppear() {
                                    dateFormatter.dateFormat = "MM/dd/yy"
                                    dateString = dateFormatter.string(from: (notes[0].createdAt ?? Date()) as Date)
                                }
                        
                        
                        Button( action: { customizeJournal.toggle() } ) {
                            Image(systemName: "pencil")
                                .font(Font.custom("Poppins-Medium", size: 20))
                                .foregroundColor(Color(UIColor(named: "PozGray")!))
                                .padding(.leading, 14)
                        }
                        .sheet(isPresented: $customizeJournal, content: {
                            CustomizeJournalView(settings: settings).environment(\.managedObjectContext, self.moc)
                        })
                    }
                }
            }
           
        }
        .frame(width: UIScreen.main.bounds.width)
    }
}

struct BookStaticView: View {
    
    @ObservedObject var settings: SettingsModel
    @Environment(\.colorScheme) var colorScheme
    
    //to get last date
    @FetchRequest(entity: Note.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Note.createdAt, ascending: false)]) var notes: FetchedResults<Note>
    
    var body: some View {
        ZStack {
            Image("book").resizable()
                .frame(width: 180, height: 250)
                .shadow(color: (colorScheme == .dark ? Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6)) : Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))), radius: 5, x: 0.0, y: 10)
                .shadow(color: (colorScheme == .dark ? Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6)) : Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))), radius: 20, x: 0.0, y: 15)
                .hueRotation(Angle(degrees: settings.journalColorAngle))
            
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
