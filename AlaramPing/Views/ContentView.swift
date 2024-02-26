import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            CustomButton(title: "Set Alarm", backgroundColor: Color.blue) {
                navigate(to: .setAlarm)
            }
            CustomButton(title: "Fetch Posts Data", backgroundColor: Color.green) {
                navigate(to: .fetchPosts)
            }
        }
    }

    private func navigate(to route: AppRoute) {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController?.present(UIHostingController(rootView: AppRouter.view(for: route)), animated: true)
        }
    }
}
