struct RequestBuilder {
    var path: String
    var method: HTTPMethod
    var headers: [String: String]?
    var body: Data?
    
    func build() throws -> URLRequest {
        guard let url = URL(string: APIConfiguration.baseURL + path) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        return request
    }
}
