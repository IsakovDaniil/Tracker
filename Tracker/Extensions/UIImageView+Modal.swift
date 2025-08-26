import UIKit


extension UIImageView {
    static func ypArrow(tintColor: UIColor = .gray) -> UIImageView {
        let imageView = UIImageView(image: UIImage.arrow)
        imageView.tintColor = tintColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
