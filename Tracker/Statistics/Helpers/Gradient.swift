import UIKit

enum FancyGradientBorder {
    static func add(to targetView: UIView, cornerRadius: CGFloat = 16, borderWidth: CGFloat = 1) {
        // Проверяем, есть ли уже градиентный слой
        if let existing = targetView.layer.sublayers?.first(where: { $0.name == "fancyGradientBorder" }) as? CAGradientLayer {
            existing.frame = targetView.bounds
            if let maskShape = existing.mask as? CAShapeLayer {
                maskShape.path = UIBezierPath(
                    roundedRect: targetView.bounds.insetBy(dx: borderWidth, dy: borderWidth),
                    cornerRadius: cornerRadius - borderWidth
                ).cgPath
            }
            return
        }
        
        // Создаём градиент
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "fancyGradientBorder"
        gradientLayer.colors = [
            UIColor(red: 253/255, green: 76/255, blue: 73/255, alpha: 1).cgColor,   // красный
            UIColor(red: 70/255, green: 230/255, blue: 157/255, alpha: 1).cgColor,  // зелёный
            UIColor(red: 0/255, green: 123/255, blue: 250/255, alpha: 1).cgColor    // синий
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        // Создаём маску
        let borderMask = CAShapeLayer()
        borderMask.lineWidth = borderWidth * 2
        borderMask.fillColor = UIColor.clear.cgColor
        borderMask.strokeColor = UIColor.black.cgColor
        borderMask.path = UIBezierPath(
            roundedRect: targetView.bounds.insetBy(dx: borderWidth, dy: borderWidth),
            cornerRadius: cornerRadius - borderWidth
        ).cgPath
        
        gradientLayer.mask = borderMask
        gradientLayer.frame = targetView.bounds
        
        targetView.layer.addSublayer(gradientLayer)
    }
    
    static func remove(from targetView: UIView) {
        targetView.layer.sublayers?.removeAll(where: { $0.name == "fancyGradientBorder" })
    }
}
