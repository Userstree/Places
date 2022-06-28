//
// Created by Dossymkhan Zhulamanov on 20.06.2022.
//

import UIKit

extension UIView {
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity

        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor = backgroundCGColor
    }
}


extension UIView {
    
    func scaleTransformInOutView(duration: TimeInterval = 0.2) {
        
        let scaleTransform = CGAffineTransform(scaleX: 0.01, y: 0.01)  // Scale
        UIView.animate(withDuration: duration, animations: {
            self.transform = scaleTransform
            self.layoutIfNeeded()
        }) { (_) in

            UIView.animate(withDuration: duration + 0.1, animations: {
                self.alpha = 1
                self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                self.layoutIfNeeded()
            })
        }
    }

    func scaleTransformToBigView(duration: TimeInterval = 0.2) {
//        let scaleTransform = CGAffineTransform(scaleX: 0.1, y: 0.1)  // Scale
        UIView.animate(withDuration: duration, animations: {
            self.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
//            self.transform = .identity
            self.layoutIfNeeded()
        })
    }
}
