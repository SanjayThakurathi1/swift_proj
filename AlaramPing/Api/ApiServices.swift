import Foundation
import Combine

protocol APIServiceProtocol {
    func request<T: Decodable>(with builder: RequestBuilder) -> AnyPublisher<T, Error>
}
struct APIService: APIServiceProtocol {
    func request<T: Decodable>(with builder: RequestBuilder) -> AnyPublisher<T, Error> {
        guard let request = try? builder.build() else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { $0 as Error }
            .flatMap { data, response -> AnyPublisher<T, Error> in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
                }
                return Just(data)
                    .decode(type: T.self, decoder: JSONDecoder())
                    .mapError { $0 as Error }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    // Add more as needed
}

struct RequestBuilder {
    var url: URL?
    var method: HTTPMethod
    var headers: [String: String]?
    var body: Data?

    func build() throws -> URLRequest {
        guard let url = url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        return request
    }
}

