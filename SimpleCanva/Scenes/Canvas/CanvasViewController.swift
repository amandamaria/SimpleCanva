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
        scroll.showsHorizontalScrollIndicator = true
        scroll.showsVerticalScrollIndicator = true
        scroll.bounces = true
        return scroll
    }()
    
    private let canvasView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let addItemButton: UIButton = {
        let button = UIButton(type: .system)
            
        // Configuração do ícone (SF Symbols)
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        let image = UIImage(systemName: "plus", withConfiguration: config)
        button.setImage(image, for: .normal)
        
        // Cores e Estilo
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        
        // Formato Circular e Sombra
        button.layer.cornerRadius = 28 // Metade da largura/altura (56/2)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.3
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let verticalGuideLine: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let horizontalGuideLine: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        setupCanvasGestures()
        setupGuideLines()
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
        scrollView.addSubview(canvasView)
        
        view.addSubview(addItemButton)
        view.bringSubviewToFront(addItemButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // 2. Canvas preso ao Content Layout Guide (isso define a área rolável)
            canvasView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            canvasView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            canvasView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            canvasView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            // 3. DEFINIR O TAMANHO REAL (Se não houver altura, o scroll vertical morre)
            canvasView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1.2),
            canvasView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1.2),
            
            addItemButton.widthAnchor.constraint(equalToConstant: 56),
            addItemButton.heightAnchor.constraint(equalToConstant: 56),
            
            addItemButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addItemButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    func setupActions() {
        addItemButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
    }
    
    func setupCanvasGestures() {
        // Tap on canvas
        let tapOutside = UITapGestureRecognizer(target: self, action: #selector(handleCanvasTap))
        // Do not cancel other gestures
        tapOutside.cancelsTouchesInView = false
        canvasView.addGestureRecognizer(tapOutside)
    }
    
    func setupGuideLines() {
        canvasView.addSubview(verticalGuideLine)
        canvasView.addSubview(horizontalGuideLine)
        
        NSLayoutConstraint.activate([
            // Linha vertical ocupa toda a altura e fica no meio
            verticalGuideLine.centerXAnchor.constraint(equalTo: canvasView.centerXAnchor),
            verticalGuideLine.widthAnchor.constraint(equalToConstant: 1),
            verticalGuideLine.topAnchor.constraint(equalTo: canvasView.topAnchor),
            verticalGuideLine.bottomAnchor.constraint(equalTo: canvasView.bottomAnchor),
            
            // Linha horizontal ocupa toda a largura e fica no meio
            horizontalGuideLine.centerYAnchor.constraint(equalTo: canvasView.centerYAnchor),
            horizontalGuideLine.heightAnchor.constraint(equalToConstant: 1),
            horizontalGuideLine.leadingAnchor.constraint(equalTo: canvasView.leadingAnchor),
            horizontalGuideLine.trailingAnchor.constraint(equalTo: canvasView.trailingAnchor)
        ])
    }

    @objc private func handleCanvasTap(_ gesture: UITapGestureRecognizer) {
        // Identify when the gestures was on canvas (not on subview/imagem)
        let location = gesture.location(in: canvasView)
        let hitView = canvasView.hitTest(location, with: nil)
        
        if hitView == canvasView {
            deselectAllItems()
        }
    }

    private func deselectAllItems() {
        canvasView.subviews.forEach { view in
            if let item = view as? DraggableImageView {
                item.isSelected = false
            }
        }
    }
}

private extension CanvasViewController {
    @objc private func didTapAddButton() {
        interactor.didTapAddImageButton()
    }
}

extension CanvasViewController: ImagePickerDelegate {
    func didSelect(item: PexelsPhoto.PexelsPhotoData) {
        guard let url = URL(string: item.src.url) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data), let self else { return }
            
            DispatchQueue.main.async {
                let visibleRect = self.canvasView.layer.visibleRect
                let frame = CGRect(x: visibleRect.midX,
                                   y: visibleRect.midY,
                                   width: CGFloat(item.width/20),
                                   height: CGFloat(item.height/20))
                
                let newItem = DraggableImageView(image: image, frame: frame)
                newItem.delegate = self
                
                self.canvasView.addSubview(newItem)
            }
        }.resume()
    }
}

extension CanvasViewController: DraggableImageViewDelegate {
    func didSnapFinish() {
        horizontalGuideLine.isHidden = true
        verticalGuideLine.isHidden = true
    }
    
    func didReachCenterX(x: CGFloat) {
        verticalGuideLine.isHidden = false
        verticalGuideLine.frame.origin.x = x
    }
    
    func didReachCenterY(y: CGFloat) {
        horizontalGuideLine.isHidden = false
        horizontalGuideLine.frame.origin.y = y
    }
}
