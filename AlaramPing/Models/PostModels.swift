import Foundation

/// Represents a post fetched from JSONPlaceholder
struct Post: Codable, Identifiable {
    let id: Int
    let title: String
    let body: String
}
