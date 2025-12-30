import Foundation
internal import UIKit


nonisolated struct PexelsPhoto: Decodable, Sendable {
    let photos: [PexelsPhotoData]
    
    enum CodingKeys: CodingKey {
        case photos
    }
    
    struct PexelsPhotoData: Decodable, Sendable {
        let id: Int
        let src: PhotoSRC
        let alt: String
        let width: Int
        let height: Int
        
        enum CodingKeys: CodingKey {
            case id
            case src
            case alt
            case width
            case height
        }
    }
    
    struct PhotoSRC: Decodable, Sendable {
        let url: String
        
        enum CodingKeys: String, CodingKey {
            case url = "small"
        }
    }
}

enum ApiError: Error {
    case decodingError
    case noData
}

protocol PexelsServicing {
    func loadData(_ completion: @escaping (Result<PexelsPhoto, ApiError>) -> Void)
}

final class PexelsService: PexelsServicing {
    
    func loadData(_ completion: @escaping (Result<PexelsPhoto, ApiError>) -> Void) {
        let urlString = "https://api.pexels.com/v1/curated?per_page=30"
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.addValue("0rWBGhCRoFiVbbq4duycTLqsvROdrjKqHdGkciUBYdubEU21DoqNC6yY",
                         forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) {data, result, _ in
            guard let data else {
                completion(.failure(.noData))
                return
            }
            do {
                let decodedResponse = try JSONDecoder().decode(PexelsPhoto.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
