import SwiftUI
import SwiftUICharts

//  all the actual daily goal charts, bar, small, big, as well as compontents for the swift ui charts

struct barGoalView : View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Note.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Note.createdAt, ascending: true)]) var notes: FetchedResults<Note>
    
    @ObservedObject var settings: SettingsModel
    
    @State var date = Date()
    @State var dateFormatter = DateFormatter();
    @State var dateString: String = ""
    
    @State var show = false
    
    var chartWidth = UIScreen.main.bounds.width-60
    
    var body : some View {
        ZStack (alignment: .center) {
            if settings.goalNumber > 0 {
                
                HStack (alignment: .center) {
                    Spacer()
                    ZStack (alignment: .leading) {
                        Rectangle()
                            .frame(width: UIScreen.main.bounds.width-60, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .foregroundColor(Color(#colorLiteral(red: 0.2391142547, green: 0.6743282676, blue: 0.9696038365, alpha: 1)).opacity(0.2))
                            .cornerRadius(25)
                        
                        Rectangle()
                            .frame(width: show ? ((calcGoalPerformance() > 1) ? chartWidth : (calcGoalPerformance()*chartWidth)) : 0, height: 12, alignment: .center)
                            .cornerRadius(25)
                            .foregroundColor(Color(#colorLiteral(red: 0.2391142547, green: 0.6743282676, blue: 0.9696038365, alpha: 1)))
                            .animation(.easeOut(duration: 2))
                    }
                    Spacer()
                }
                .onAppear() {
                    show = true
                }
                
                HStack (spacing: 2) {
                    Text("\(countEntriesToday())/\(settings.goalNumber)")
                        .font(Font.custom("Poppins-Medium", size: (UIScreen.main.bounds.width > 420 ? ((UIScreen.main.bounds.width/2)/18) : ((UIScreen.main.bounds.width/2)/12))))
//                        .foregroundColor(Color(#colorLiteral(red: 0.2391142547, green: 0.6743282676, blue: 0.9696038365, alpha: 1)))
                    Text(" entries completed today")
                        .font(Font.custom("Poppins-Light", size: (UIScreen.main.bounds.width > 420 ? ((UIScreen.main.bounds.width/2)/18) : ((UIScreen.main.bounds.width/2)/12))))
                        .foregroundColor(Color(UIColor(named: "PozGray")!))
                }
                .offset(x: 0, y: -25)
            } else {
                HStack (alignment: .center) {
                    Spacer()
                    Text("Click to set a daily goal 🎯")
                        .font(Font.custom("Poppins-Light", size: (UIScreen.main.bounds.width > 420 ? ((UIScreen.main.bounds.width/2)/18) : ((UIScreen.main.bounds.width/2)/12))))
                        .foregroundColor(Color(UIColor(named: "PozGray")!))
                        .padding(.bottom, 10)
                    Spacer()
                }
            }
        }
        .onAppear() {
            dateFormatter.dateFormat = "MM/dd/yy"
            dateString = dateFormatter.string(from: (notes[0].createdAt ?? Date()) as Date)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                show = true
            }
        }
    }
    
    func calcGoalPerformance () -> CGFloat {
        return (CGFloat(countEntriesToday()))/(CGFloat(settings.goalNumber))
    }
    
    func countEntriesToday () -> Int {
        var entriesToday = 0
        
        for note in notes {
            let isToday = Calendar.current.isDateInToday(note.lastUpdated ?? Date().addingTimeInterval(1000000))
            
            if(isToday && note.note != settings.welcomeText && note.note != "") {
                entriesToday += 1
            }
            
        }
        return entriesToday
    }
}

struct smallGoalView : View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Note.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Note.createdAt, ascending: true)]) var notes: FetchedResults<Note>
    
    
    @ObservedObject var settings: SettingsModel
    
    @State var date = Date()
    @State var dateFormatter = DateFormatter();
    @State var dateString: String = ""
    
    @State var show = false
    
    var body : some View {
        ZStack {
            if settings.goalNumber > 0 {
                if show {
                    RingView(color: Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), endVal: ((CGFloat(countEntriesToday()))/(CGFloat(settings.goalNumber)) == 0.0) ? 0.01 : ((CGFloat(countEntriesToday()))/(CGFloat(settings.goalNumber))), sizeScale: 0.4, animateOn: true)
                }
                
                Text("\(countEntriesToday())/\(settings.goalNumber)")
                    .font(Font.custom("Poppins-Bold", size: (countEntriesToday() > 9 ? UIScreen.main.bounds.width/2/15 : UIScreen.main.bounds.width/2/14)))
                    .foregroundColor(Color(UIColor(named: "PozBlue")!))
            }
        }
        .onAppear() {
           // countEntriesToday()
            dateFormatter.dateFormat = "MM/dd/yy"
            dateString = dateFormatter.string(from: (notes[0].createdAt ?? Date()) as Date)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                show = true
            }
        }
    }
    
    func countEntriesToday () -> Int {
        var entriesToday = 0
        
        for note in notes {
            let isToday = Calendar.current.isDateInToday(note.lastUpdated ?? Date().addingTimeInterval(1000000))
            
            if(isToday && note.note != settings.welcomeText && note.note != "") {
                entriesToday += 1
            }
            
        }
        return entriesToday
    }
}


struct bigGoalView : View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Note.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Note.createdAt, ascending: true)]) var notes: FetchedResults<Note>
    
    
    @ObservedObject var settings: SettingsModel
    
    @State var date = Date()
    @State var dateFormatter = DateFormatter();
    @State var dateString: String = ""
    
    @State var show = true
    
    var body : some View {
        ZStack {
            if settings.goalNumber > 0 {
                if show {
                    RingView(color: Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), endVal: (calcGoalPerformance() == 0.0) ? 0.01 : (calcGoalPerformance()), sizeScale: 2, animateOn: false)
//                        .animation(.easeOut(duration: 2))
//                        .onChange(of: calcGoalPerformance()) { value in
//                            print (calcGoalPerformance())
//                            print(settings.goalNumber)
//                        }
                }
                
                Text("\(countEntriesToday())/\(settings.goalNumber)")
                    .font(Font.custom("Poppins-Bold", size: (countEntriesToday() > 9 ? UIScreen.main.bounds.width/2/7 : UIScreen.main.bounds.width/2/6)))
                    .foregroundColor(Color(UIColor(named: "PozBlue")!))
            }
        }
        .onAppear() {
           // countEntriesToday()
            dateFormatter.dateFormat = "MM/dd/yy"
            dateString = dateFormatter.string(from: (notes[0].createdAt ?? Date()) as Date)
        }
    }
    
    func calcGoalPerformance () -> CGFloat {
        return (CGFloat(countEntriesToday()))/(CGFloat(settings.goalNumber))
    }
    
    func countEntriesToday () -> Int {
        var entriesToday = 0
        
        for note in notes {
            let isToday = Calendar.current.isDateInToday(note.lastUpdated ?? Date().addingTimeInterval(1000000))
            
            if(isToday && note.note != settings.welcomeText && note.note != "") {
                entriesToday += 1
            }
            
        }
        return entriesToday
    }
}



struct ChartView: View {
    @State var tabIndex:Int = 0
    var body: some View {
        VStack {
            HStack {
                BarCharts()
                LineCharts()
            }
//            PieCharts()
            LineChartsFull()
        }
    }
    
}

struct BarCharts:View {
    var body: some View {
        VStack{
            BarChartView(data: ChartData(points: [8,23,54,32,12,37,7,23,43]), title: "Title", style: Styles.barChartStyleOrangeLight, form: ChartForm.medium, dropShadow: false)
        }
    }
}

struct LineCharts:View {
    var body: some View {
        VStack{
            LineChartView(data: [8,23,54,32,12,37,7,23,43], title: "Title", form: ChartForm.detail, dropShadow: false)
        }
    }
}

struct PieCharts:View {
    var body: some View {
        VStack{
            PieChartView(data: [8,23,54,32,12,37,7,23,43], title: "Title")
        }
    }
}

struct LineChartsFull: View {
    var body: some View {
        VStack{
            LineView(data: [8,23,54,32,12,37,7,23,43], title: "Line chart", legend: "Full screen").padding()
            // legend is optional, use optional .padding()
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}
