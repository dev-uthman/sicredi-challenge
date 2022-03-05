//
//  BaseViewController.swift
//  SicrediChallenge
//
//  Created by Diego Rodrigues Abdala Uthman on 05/03/22.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    lazy var contentView: UIView = {
        $0.backgroundColor = .black
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView(frame: .zero))
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        
        let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        view.color = .white
        view.startAnimating()
        
        view.center = self.view.center
        return view
    }()
    
    func addLoading() {
        DispatchQueue.main.async { [contentView, fadeIn] in
            guard let window = UIApplication.shared.windows.first else { return }
            window.addSubview(contentView)
            contentView.alpha = 0.5
            contentView.topAnchor.constraint(equalTo: window.topAnchor).isActive = true
            contentView.leftAnchor.constraint(equalTo: window.leftAnchor).isActive = true
            contentView.rightAnchor.constraint(equalTo: window.rightAnchor).isActive = true
            contentView.bottomAnchor.constraint(equalTo: window.bottomAnchor).isActive = true
            
            fadeIn()
        }
    }
    
    func hideLoading() {
        fadeOut()
    }
    
    private func fadeIn() {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            self.contentView.alpha = 0.5
        }) { (bool: Bool) in
            self.contentView.addSubview(self.activityIndicatorView)
        }
    }
    
    private func fadeOut() {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            self.contentView.alpha = 0.0
        }) { [contentView] (bool: Bool) in
            contentView.removeFromSuperview()
        }
    }
}
