import SwiftUI

struct OnboardingStepView: View {
    var data: OnboardingDataModel
    @State var textString = ""
    var body: some View {
        VStack {
            Image(data.image)
                .resizable()
                .scaledToFit()
                .padding(.bottom, 50)
            TextField("HI", text: $textString)
            Text(data.heading)
                .font(.system(size: 25, design: .rounded))
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            Text(data.text)
                .font(.system(size: 17, design: .rounded))
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
    .padding()
    }
}

struct OnboardingStepView_Previews: PreviewProvider {
    static var data = OnboardingDataModel.data[0]
    static var previews: some View {
        OnboardingStepView(data: data)
    }
}
