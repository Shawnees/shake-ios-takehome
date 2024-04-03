import UIKit

extension UIView {

    func fillSuperView(offset: CGFloat) {
        guard let superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: offset),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -offset),
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: offset),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -offset)
        ])
    }
}
