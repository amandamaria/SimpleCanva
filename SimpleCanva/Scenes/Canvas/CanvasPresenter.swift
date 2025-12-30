internal import UIKit

protocol CanvasPresenting {
    func openImagePicker()
}

final class CanvasPresenter: CanvasPresenting {
    weak var viewController: CanvasViewController?

    func openImagePicker() {
        // TODO: Open bottom sheet
    }
}
