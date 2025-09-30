import UIKit


extension UIImageView {
    static func ypArrow(tintColor: UIColor = .gray) -> UIImageView {
        let imageView = UIImageView(image: UIImage.arrow)
        imageView.tintColor = tintColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    static func stubImage() -> UIImageView {
        let imageView = UIImageView(image: UIImage.dizzyStar)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
