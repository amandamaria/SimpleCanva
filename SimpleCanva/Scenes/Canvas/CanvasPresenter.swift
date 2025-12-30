internal import UIKit

protocol CanvasPresenting {
    
}

final class CanvasPresenter {
    weak var viewController: CanvasViewController?
}

extension CanvasPresenter: CanvasPresenting {
    
}
