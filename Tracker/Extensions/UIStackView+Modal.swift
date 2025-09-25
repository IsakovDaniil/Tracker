import UIKit

extension UIStackView {
    static func stubStack(axis: NSLayoutConstraint.Axis = .vertical,
                          spacing: CGFloat = TrackersViewConstants.Layout.stubStackSpacing,
                          alignment: UIStackView.Alignment = .center,
                          distribution: UIStackView.Distribution = .equalCentering) -> UIStackView {
        let stack = UIStackView()
        stack.axis = axis
        stack.spacing = spacing
        stack.alignment = alignment
        stack.distribution = distribution
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
}
