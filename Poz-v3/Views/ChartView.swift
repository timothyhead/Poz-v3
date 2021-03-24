import SwiftUI
import SwiftUICharts

struct smallGoalView : View {
    var body : some View {
        HStack {
            Spacer()
            ZStack {
                RingView(color: Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), endVal: 0.5, sizeScale: 1.0)
                
                Text("1/2")
                    .font(Font.custom("Poppins-Bold", size: 24))
                    .foregroundColor(Color(UIColor(named: "PozBlue")!))
            }
            Text("Entries added today")
                .foregroundColor(Color.primary)
                .font(Font.custom("Poppins-Light", size: 18))
                .padding(.leading, 15)
            Spacer()
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
