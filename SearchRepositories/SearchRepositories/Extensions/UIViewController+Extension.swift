//
//  UIViewController+Extension.swift
//  SearchRepositories
//
//  Created by user on 2021/12/05.
//

import Foundation
import UIKit

extension UIViewController {
    func showToast(_ message : String) {
        let toastLabel = UILabel(
            frame: CGRect(
                x: 20,
                y: self.view.frame.size.height / 3,
                width: self.view.frame.size.width - 40,
                height: 100
            )
        )
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0
        toastLabel.lineBreakMode = .byCharWrapping
        self.view.addSubview(toastLabel)
        UIView.animate(
            withDuration: 5.0,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            }
        )
    }
}
