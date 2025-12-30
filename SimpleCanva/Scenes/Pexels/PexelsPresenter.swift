internal import UIKit

protocol PexelsPresenting {
    func presentData(_ data: PexelsPhoto)
}

final class PexelsPresenter: PexelsPresenting {
    weak var viewController: PexelsViewController?
    
    func presentData(_ data: PexelsPhoto) {
        viewController?.showData(data.photos)
    }
}
