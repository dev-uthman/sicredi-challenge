//
//  EventCollectionViewCell.swift
//  SicrediChallenge
//
//  Created by Diego Rodrigues Abdala Uthman on 05/03/22.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: EventCollectionViewCell.self)
    
    var delegate: LoadUIImageViewDelegate?
    
    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var textTitle: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.bold)
        $0.numberOfLines = 0
        $0.sizeToFit()
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .black
        return $0
    }(UILabel())
    
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupUI() {
        addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(textTitle)
        
        containerView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        containerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        containerView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        imageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5).isActive = true
        imageView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5).isActive = true
        imageView.bottomAnchor.constraint(equalTo: textTitle.topAnchor, constant: 10).isActive = true
 
        textTitle.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        textTitle.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        textTitle.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 10).isActive = true
        textTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textTitle.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 10).isActive = true

        imageView.layer.cornerRadius = 30
        imageView.layer.shadowOffset = CGSize(width: 3, height: 3)
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowRadius = 4
        imageView.clipsToBounds = true

    }
    
    internal func configImage(urlImage: String, title: String) {
        textTitle.text = title.uppercased()
        DispatchQueue.global(qos: .background).async { [imageView, setNeedsLayout, delegate] in
            imageView.setDownloadImage(url: urlImage, delegate)
            setNeedsLayout()
        }
    }
    
    internal func configImage(image: UIImage, title: String) {
        imageView.image = image
        textTitle.text = title.uppercased()
        setNeedsLayout()
    }
}

extension EventCollectionViewCell: LoadUIImageViewDelegate {
    func fullDownloadImage(dictionary: [String : UIImage]) {
        delegate?.fullDownloadImage(dictionary: dictionary)
    }
}


