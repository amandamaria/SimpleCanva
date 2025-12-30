internal import UIKit

protocol CanvasPresenting {
    func openImagePicker()
}

final class CanvasPresenter: CanvasPresenting {
    weak var viewController: CanvasViewController?

    func openImagePicker() {
        let presenter = PexelsPresenter()
        let interactor = PexelsInteractor(presenter: presenter)
        let pickerVC = PexelsViewController(interactor: interactor)
        presenter.viewController = pickerVC
        pickerVC.delegate = self.viewController
        
        // Open Bottom Sheet
        if let sheet = pickerVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()] // half screen
            sheet.prefersGrabberVisible = true      // Enable resize control
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.largestUndimmedDetentIdentifier = .medium // Interaction to bottom view enabled
        }
        
        viewController?.present(pickerVC, animated: true)
    }
}
