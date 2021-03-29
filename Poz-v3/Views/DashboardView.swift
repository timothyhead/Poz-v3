import SwiftUI

struct DashboardView: View {
    
    @State var prevPostsShowing = false
    
    @ObservedObject var settings: SettingsModel
    
    var body: some View {
        ScrollView (.vertical, showsIndicators: false) {
            VStack (spacing: 20) {
                
                //Chart Block
//                VStack {
//                    HStack (spacing: 0) {
//                        Text("Your daily ")
//                            .font(Font.custom("Poppins-Light", size: 26))
//                            .foregroundColor(Color(UIColor(named: "PozGray")!))
//                        Text("goal")
//                            .font(Font.custom("Poppins-Medium", size: 26))
//
//                        Spacer()
//
//                        Button(action: {}) {
//                            Text("Edit")
//                                .font(Font.custom("Poppins-Regular", size: 16))
//                        }
//
//                    }.padding()
//
//                    ZStack {
//                        RingView(color: Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), endVal: 0.5, sizeScale: 3.0)
//
//                        VStack {
//                            Text("1/2")
//                                .font(Font.custom("Poppins-Bold", size: 90))
//                                .foregroundColor(Color(UIColor(named: "PozBlue")!))
//                                .padding(.bottom, -15)
//                            Text("Entries added today")
//                                .foregroundColor(Color.primary)
//                                .font(Font.custom("Poppins-Light", size: 18))
//
//                        }
//                    }
//                    HStack (spacing: 0) {
//                        Text("Reminders at ")
//                            .font(Font.custom("Poppins-Light", size: 18))
//                            .foregroundColor(Color(UIColor(named: "PozGray")!))
//                        Text("9:00am")
//                            .font(Font.custom("Poppins-Medium", size: 18))
//                        Text(" & ")
//                            .font(Font.custom("Poppins-Light", size: 18))
//                            .foregroundColor(Color(UIColor(named: "PozGray")!))
//                        Text("8:00pm")
//                            .font(Font.custom("Poppins-Medium", size: 18))
//                    }
//                }
                
//                Divider().padding()
                
                //previous posts button
                Button (action:{ prevPostsShowing.toggle() }) {
                    HStack (spacing: 0) {
                        Text("See all your ")
                            .font(Font.custom("Poppins-Light", size: 22))
                            .foregroundColor(Color(UIColor(named: "PozGray")!))
                        Text("past posts")
                            .font(Font.custom("Poppins-Medium", size: 22))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        Image(systemName: "chevron.right").resizable().frame(width: 10, height: 20)
                            .foregroundColor(.primary)
                    }
                }.padding(.horizontal, 20)
                .sheet(isPresented: $prevPostsShowing, content: {
                    NotesListView(settings: settings)
                })
                
                Divider().padding()
                
//                ChartView()
            }
            .preferredColorScheme((settings.darkMode == true ? (.dark) : (.light)))
//            .padding(.top, 60)
            .padding(.horizontal, 30)
//            .padding(.bottom, 80)
        }
        .background(Color(UIColor(named: "HomeBG")!))
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

//struct DashboardView_Previews: PreviewProvider {
//    static var previews: some View {
//        DashboardView()
//    }
//}
