internal import UIKit

final class DraggableImageView: UIImageView, UIGestureRecognizerDelegate {
    
    var isSelected: Bool = false {
        didSet {
            layer.borderWidth = isSelected ? 3 : 0
            layer.borderColor = UIColor.systemBlue.cgColor
        }
    }
    private let snapThreshold: CGFloat = 20.0
    
    init(image: UIImage?, frame: CGRect) {
        super.init(frame: frame)
        self.image = image
        self.isUserInteractionEnabled = true
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        
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
        
        // --- LÓGICA DE SNAP (REQUISITO DO PROJETO) ---
        // Se estiver perto do centro horizontal do canvas, "gruda"
        if abs(newCenter.x - superview.center.x) < snapThreshold {
            newCenter.x = superview.center.x
            // Aqui você poderia ativar um feedback visual (vibração ou linha)
        }
        
        // Se estiver perto do centro vertical do canvas, "gruda"
        if abs(newCenter.y - superview.center.y) < snapThreshold {
            newCenter.y = superview.center.y
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
        }
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        // Primeiro, desmarca todos os outros itens no mesmo canvas
        superview?.subviews.forEach { ($0 as? DraggableImageView)?.isSelected = false }
        // Seleciona este
        self.isSelected = true
        // Traz para a frente de todos os outros
        superview?.bringSubviewToFront(self)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
    }
}
