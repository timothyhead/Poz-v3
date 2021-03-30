import SwiftUI
import ConcentricOnboarding


struct OnboardingView: View {
    
    @ObservedObject var settings: SettingsModel
    
    @Binding var tabIndex: Int

    var body: some View {
        
        let pages = (0...2).map { i in
            AnyView(PageView(title: MockData.title, imageName: MockData.imageNames[i], header: MockData.headers[i], content: MockData.contentStrings[i], textColor: MockData.textColors[i], settings: settings))
        }

        var onboardingPages = ConcentricOnboardingView(pages: pages, bgColors: MockData.colors)

//        a.didPressNextButton = {
//            a.goToPreviousPage(animated: true)
//        }
//        
        onboardingPages.insteadOfCyclingToFirstPage = {
            tabIndex = 0
        }
        
//        onboardingPages.animationDidEnd = {
//
//        }
//        onboardingPages.didGoToLastPage = {
//        }
        
        return onboardingPages
        
    }
}

