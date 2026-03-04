import SwiftUI

// MARK: - Splash Screen
struct SplashView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Image("NightlyIcon") // Replace with your logo image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.accentColor)
                    .shadow(radius: 10)

                Text("Nightly") // App Name
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.accentColor)
            }
        }
    }
}
