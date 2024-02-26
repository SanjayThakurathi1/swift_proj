class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }

    func fetchPosts() {
        let builder = RequestBuilder(path: "/posts", method: .get)
        isLoading = true
        
        apiService.request(with: builder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = "Failed to fetch posts: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] (posts: [Post]) in
                self?.posts = posts
            })
            .store(in: &cancellables)
    }
}
