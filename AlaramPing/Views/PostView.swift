import SwiftUI

struct PostsView: View {
    @StateObject var viewModel = PostViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    // Customized Loader View
                    LoaderView()
                } else if let errorMessage = viewModel.errorMessage {
                    // Error Message View
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    // Content List
                    listContentView
                }
            }
            .navigationTitle("Posts")
            .onAppear {
                viewModel.fetchPosts()
            }
        }
    }
    
    private var listContentView: some View {
        List(viewModel.posts) { post in
            VStack(alignment: .leading) {
                Text(post.title)
                    .font(.headline)
                Text(post.body)
                    .font(.subheadline)
                    .lineLimit(3)
            }
        }
    }
}

struct LoaderView: View {
    var body: some View {
        VStack {
            ProgressView("Loading...")
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(1.5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground).opacity(0.8))
    }
}
