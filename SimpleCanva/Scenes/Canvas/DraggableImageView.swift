internal import UIKit

protocol DraggableImageViewDelegate: AnyObject {
    func didReachCenterX(x: CGFloat)
    func didReachCenterY(y: CGFloat)
    func didSnapFinish()
}

final class DraggableImageView: UIImageView, UIGestureRecognizerDelegate {
    
    weak var delegate: DraggableImageViewDelegate?
    
    var isSelected: Bool = false {
        didSet {
            layer.borderWidth = isSelected ? 3 : 0
            layer.borderColor = UIColor.systemBlue.cgColor
            selectionOverlay.isHidden = !isSelected
        }
    }
    
    private let selectionOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let snapThreshold: CGFloat = 10.0
    
    init(image: UIImage?, frame: CGRect) {
        super.init(frame: frame)
        self.image = image
        self.isUserInteractionEnabled = true
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        
        setupOverlay()
        setupGesture()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.addGestureRecognizer(pan)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        pinch.delegate = self
        self.addGestureRecognizer(pinch)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let superview = superview else { return }
        let translation = gesture.translation(in: superview)
        
        // Nova posição baseada no movimento do dedo
        var newCenter = CGPoint(x: self.center.x + translation.x,
                                y: self.center.y + translation.y)
        
        // Definição do tamanho do grid
        let gridX: CGFloat = 50
        let gridY: CGFloat = 50
        
        // Cálculo do ponto do grid mais próximo
        let closestGridX = (newCenter.x / gridX).rounded() * gridX
        let closestGridY = (newCenter.y / gridY).rounded() * gridY
        
        let reachCenterX = abs(newCenter.x - closestGridX) < snapThreshold
        let reachCenterY = abs(newCenter.y - closestGridY) < snapThreshold
        
        // Esconde as linhas quando o gesto termina
        if gesture.state == .changed && !(reachCenterX || reachCenterY) {
            delegate?.didSnapFinish()
        }
        
        // --- LÓGICA DE SNAP (REQUISITO DO PROJETO) ---
        // Se estiver perto do centro horizontal do canvas, "gruda"
        if reachCenterX {
            delegate?.didReachCenterX(x: closestGridX)
        }
        
        // Se estiver perto do centro vertical do canvas, "gruda"
        if reachCenterY {
            delegate?.didReachCenterY(y: closestGridY)
        }
        
        // Esconde as linhas quando o gesto termina
        if gesture.state == .ended || gesture.state == .cancelled {
            delegate?.didSnapFinish()
            if reachCenterX {
                newCenter.x = closestGridX
            }
            
            if reachCenterY {
                newCenter.y = closestGridY
            }
            isSelected = false
        } else {
            isSelected = true
        }
        
        self.center = newCenter
        gesture.setTranslation(.zero, in: superview)
    }
    
    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let view = gesture.view else { return }
            
        // Pegamos a referência da scrollview subindo na hierarquia
        let scrollView = self.superview?.superview as? UIScrollView

        if gesture.state == .began {
            // DESLIGAMOS o gesto do scroll temporariamente
            // Isso não altera o delegate, apenas desativa o reconhecimento
            scrollView?.pinchGestureRecognizer?.isEnabled = false
        }
        
        if gesture.state == .changed {
            view.transform = view.transform.scaledBy(x: gesture.scale, y: gesture.scale)
            gesture.scale = 1.0
        }
        
        if gesture.state == .ended || gesture.state == .cancelled {
            // RELIGAMOS o gesto do scroll
            scrollView?.pinchGestureRecognizer?.isEnabled = true
            isSelected = false
        }
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        updateSelection()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
    }
}

private extension DraggableImageView {
    func setupOverlay() {
        addSubview(selectionOverlay)
        
        NSLayoutConstraint.activate([
            selectionOverlay.topAnchor.constraint(equalTo: topAnchor),
            selectionOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectionOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectionOverlay.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func updateSelection() {
        // Primeiro, desmarca todos os outros itens no mesmo canvas
        superview?.subviews.forEach { ($0 as? DraggableImageView)?.isSelected = false }
        // Seleciona este
        self.isSelected = true
        // Traz para a frente de todos os outros
        superview?.bringSubviewToFront(self)
    }
}
