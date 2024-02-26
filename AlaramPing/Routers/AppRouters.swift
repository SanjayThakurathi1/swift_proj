// In AppRouter.swift
enum AppRoute {
    case main
    case setAlarm
    case fetchPosts
}
import SwiftUI

class AppRouter {
    @ViewBuilder
    static func view(for route: AppRoute) -> some View {
        switch route {
        case .main:
            ContentView()
        case .setAlarm:
            AlarmView()
        case .fetchPosts:
            PostsView()
        }
    }
}
