//
//  Created by Amanda Maria on 29/12/25.
//

internal import UIKit

final class CanvasViewController: UIViewController {
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = .systemGray6
        scroll.minimumZoomScale = 0.5
        scroll.maximumZoomScale = 2.0
        return scroll
    }()
    
    private let canvasView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }()
    
    private let addItemButton: UIButton = {
        let button = UIButton(type: .contactAdd)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let interactor: CanvasInteracting
    
    init(interactor: CanvasInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        setupHierarchy()
        setupConstraints()
        setupActions()
    }
    
}

extension CanvasViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return canvasView
    }
}

private extension CanvasViewController {
    func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(addItemButton)
        scrollView.addSubview(canvasView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            canvasView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            canvasView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            canvasView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            canvasView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.5),
            canvasView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            addItemButton.bottomAnchor.constraint(equalTo: canvasView.topAnchor, constant: -20),
            addItemButton.trailingAnchor.constraint(equalTo: canvasView.trailingAnchor, constant: -20),
        ])
    }
    
    func setupActions() {
        addItemButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
    }
}

private extension CanvasViewController {
    @objc private func didTapAddButton() {
        // TODO: call interactor
    }
}

