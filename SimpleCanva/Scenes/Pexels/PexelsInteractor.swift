import Foundation

protocol PexelsInteracting {
    func loadData()
}

final class PexelsInteractor: PexelsInteracting {
    let service = PexelsService()
    let presenter: PexelsPresenting
    
    init(presenter: PexelsPresenting) {
        self.presenter = presenter
    }
    
    func loadData() {
        service.loadData { result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result {
                case let .success(data):
                    presenter.presentData(data)
                case let .failure(error):
                    debugPrint(error)
                }
            }
        }
    }
}
