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
        
        enum CodingKeys: CodingKey {
            case id
            case src
            case alt
        }
    }
    
    struct PhotoSRC: Decodable, Sendable {
        let small: String
        
        enum CodingKeys: CodingKey {
            case small
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
        // TODO: Call to service
    }
}
