import SwiftUI
import SwiftUICharts

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
        .frame(height: 550).padding()
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
