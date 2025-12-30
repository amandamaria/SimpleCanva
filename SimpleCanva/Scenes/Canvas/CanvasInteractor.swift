protocol CanvasInteracting {
    
}

final class CanvasInteractor {
    let presenter: CanvasPresenting
    
    init(presenter: CanvasPresenting) {
        self.presenter = presenter
    }

}

extension CanvasInteractor: CanvasInteracting {
    
}
