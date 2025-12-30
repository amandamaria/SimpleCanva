protocol CanvasInteracting {
    func didTapAddImageButton()
}

final class CanvasInteractor: CanvasInteracting {
    let presenter: CanvasPresenting
    
    init(presenter: CanvasPresenter) {
        self.presenter = presenter
    }
    
    func didTapAddImageButton() {
        presenter.openImagePicker()
    }
}
