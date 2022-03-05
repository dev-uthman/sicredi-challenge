//
//  UIImageView+Misc.swift
//  SicrediChallenge
//
//  Created by Diego Rodrigues Abdala Uthman on 05/03/22.
//

import UIKit

extension UIImageView {
    func setDownloadImage(url urlString: String, _ delegate: LoadUIImageViewDelegate?) {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        addLoading(indicator)
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    indicator.removeFromSuperview()
                    
                    self.image  = UIImage(data: data)
                    self.setNeedsLayout()
                    delegate?.fullDownloadImage(dictionary: [urlString: self.image ?? UIImage()])
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    indicator.removeFromSuperview()
                    self.image = UIImage(named: "broken")
                    delegate?.fullDownloadImage(dictionary: [urlString: self.image ?? UIImage()])
                }
            }
        }
    }
    func addLoading(_ indicator: UIActivityIndicatorView) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            indicator.color = .black
            indicator.startAnimating()
            indicator.center = self.center
            indicator.translatesAutoresizingMaskIntoConstraints = false
            
            self.addSubview(indicator)
            
            indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
            indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        }
    }
}
   
protocol LoadUIImageViewDelegate {
    func fullDownloadImage(dictionary : [String: UIImage])
}

