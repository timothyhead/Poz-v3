import SwiftUI
import SwiftUICharts

struct barGoalView : View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Note.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Note.createdAt, ascending: true)]) var notes: FetchedResults<Note>
    
    @ObservedObject var settings: SettingsModel
    
    @State var date = Date()
    @State var dateFormatter = DateFormatter();
    @State var dateString: String = ""
    
    @State var entriesToday = 0
    
    @State var show = false
    
    var body : some View {
        ZStack (alignment: .leading) {
            if settings.goalNumber > 0 {
                
                Rectangle().frame(width: 400, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding()
                Rectangle().frame(width: 200, height: 10, alignment: .center)
                
                
                if show {
//                    RingView(color: Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), endVal: ((CGFloat(entriesToday))/(CGFloat(settings.goalNumber)) == 0.0) ? 0.01 : ((CGFloat(entriesToday))/(CGFloat(settings.goalNumber))), sizeScale: 0.4, animateOn: true)
                }
                
                Text("\(entriesToday)/\(settings.goalNumber)")
                    .font(Font.custom("Poppins-Bold", size: (entriesToday > 9 ? 12.5 : 16)))
                    .foregroundColor(Color(UIColor(named: "PozBlue")!))
            }
        }
        .onAppear() {
            countEntriesToday()
            dateFormatter.dateFormat = "MM/dd/yy"
            dateString = dateFormatter.string(from: (notes[0].createdAt ?? Date()) as Date)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                show = true
            }
        }
    }
    
    func countEntriesToday () {
        for note in notes {
            
//            let sameDay = Calendar.current.isDate(date, equalTo: note.createdAt ?? Date().addingTimeInterval(100000), toGranularity: .day)
            let isToday = Calendar.current.isDateInToday(note.createdAt ?? Date().addingTimeInterval(100000))
            
            if (isToday && note.note != settings.welcomeText ) {
                entriesToday += 1
            }
        }
    }
}

struct smallGoalView : View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Note.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Note.createdAt, ascending: true)]) var notes: FetchedResults<Note>
    
    
    @ObservedObject var settings: SettingsModel
    
    @State var date = Date()
    @State var dateFormatter = DateFormatter();
    @State var dateString: String = ""
    
    @State var entriesToday = 0
    
    @State var show = false
    
    var body : some View {
        ZStack {
            if settings.goalNumber > 0 {
                if show {
                    RingView(color: Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), endVal: ((CGFloat(entriesToday))/(CGFloat(settings.goalNumber)) == 0.0) ? 0.01 : ((CGFloat(entriesToday))/(CGFloat(settings.goalNumber))), sizeScale: 0.4, animateOn: true)
                }
                
                Text("\(entriesToday)/\(settings.goalNumber)")
                    .font(Font.custom("Poppins-Bold", size: (entriesToday > 9 ? UIScreen.main.bounds.width/2/15 : UIScreen.main.bounds.width/2/14)))
                    .foregroundColor(Color(UIColor(named: "PozBlue")!))
            }
        }
        .onAppear() {
            countEntriesToday()
            dateFormatter.dateFormat = "MM/dd/yy"
            dateString = dateFormatter.string(from: (notes[0].createdAt ?? Date()) as Date)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                show = true
            }
        }
    }
    
    func countEntriesToday () {
        for note in notes {
            
//            let sameDay = Calendar.current.isDate(date, equalTo: note.createdAt ?? Date().addingTimeInterval(100000), toGranularity: .day)
            let isToday = Calendar.current.isDateInToday(note.createdAt ?? Date().addingTimeInterval(100000))
            
            if (isToday && note.note != settings.welcomeText && note.note != "") {
                entriesToday += 1
            }
        }
    }
}

struct bigGoalView : View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Note.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Note.createdAt, ascending: true)]) var notes: FetchedResults<Note>
    
    @ObservedObject var settings: SettingsModel
    
    @State var date = Date()
    @State var dateFormatter = DateFormatter();
    @State var dateString: String = ""
    
    @State var entriesToday = 0
    
    @State var show = false
    
    var body : some View {
        ZStack {
            if settings.goalNumber > 0 {
                if show {
                    RingView(color: Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), endVal: ((CGFloat(entriesToday))/(CGFloat(settings.goalNumber)) == 0.0) ? 0.01 : ((CGFloat(entriesToday))/(CGFloat(settings.goalNumber))), sizeScale: 2, animateOn: false)
                }
                
                Text("\(entriesToday)/\(settings.goalNumber)")
                    .font(Font.custom("Poppins-Bold", size: (entriesToday > 9 ? 36 : 48)))
                    .foregroundColor(Color(UIColor(named: "PozBlue")!))
            }
        }
        .onAppear() {
            countEntriesToday()
            dateFormatter.dateFormat = "MM/dd/yy"
            dateString = dateFormatter.string(from: (notes[0].createdAt ?? Date()) as Date)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                show = true
            }
        }
    }
    
    func countEntriesToday () {
        for note in notes {
            
//            let sameDay = Calendar.current.isDate(date, equalTo: note.createdAt ?? Date().addingTimeInterval(100000), toGranularity: .day)
            let isToday = Calendar.current.isDateInToday(note.createdAt ?? Date().addingTimeInterval(100000))
            
            if (isToday && note.note != settings.welcomeText && note.note != "") {
                entriesToday += 1
            }
        }
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
