//
//  EventDetailsViewController.swift
//  SicrediChallenge
//
//  Created by Diego Rodrigues Abdala Uthman on 06/03/22.
//

import UIKit
import RxSwift

class EventDetailsViewController: BaseViewController {
    
    var viewModel: EventDetailViewModel?
    var disposeBag = DisposeBag()
    
    var descriptionLabel: UILabel = {
        $0.font = UIFont(name: "Courier Regular", size: 15)
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.sizeToFit()
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    var dataLabel: UILabel = {
        $0.font = UIFont(name: "Courier Bold", size: 15)
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.sizeToFit()
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    var priceLabel: UILabel = {
        $0.font = UIFont(name: "Courier Bold", size: 15)
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.sizeToFit()
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    lazy var imageView: UIImageView = {
        $0.contentMode = .scaleToFill
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.roundedImage()
        return $0
    }(UIImageView())
    
    var sharedFloatingButton: UIButton = {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 25
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named: "ic_shared"), for: .normal)
        $0.addTarget(self, action: #selector(shareButtonClicked), for: .touchUpInside)
        return $0
    }(UIButton(type: .custom))
    
    var mapsFloatingButton: UIButton = {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 25
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named: "ic_maps"), for: .normal)
        $0.addTarget(self, action: #selector(mapsButtonClicked), for: .touchUpInside)
        return $0
    }(UIButton(type: .custom))
    
    var scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLoading()
        viewModel?.fetchEventById()
        setupUI()
        setupNavBar()
        bindRx()
    }
    
    convenience init(viewModel: EventDetailViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    private func bindRx() {
        viewModel?
            .event
            .observe(on: MainScheduler.asyncInstance)
            .filter {$0 != nil}
            .subscribe(onNext: { [weak self] event in
                guard let self = self else { return }
                self.hideLoading()
                guard let event = event else { return }
                self.descriptionLabel.text = event.description
                self.title = self.createTitle(event.title)
                self.imageView.setDownloadImage(url: event.image, self, backgroundColor: .white)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE, dd MMMM"
                self.dataLabel.text = "\(dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(event.date))))".capitalized
                self.priceLabel.text = "Custo de R$\(event.price)"
            }).disposed(by: disposeBag)
    }
    
    private func setupNavBar() {
        let checkIn = UIBarButtonItem(title: "Check-In", style: .plain, target: self, action: #selector(addTappedCheckIn))
        navigationItem.rightBarButtonItems = [checkIn]
    }
    
    @objc func addTappedCheckIn() {
        let viewModel = CheckInViewModel(idEvent: viewModel?.idEvent ?? "")
        let vc = CheckInViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func shareButtonClicked(sender: AnyObject) {
        let objectsToShare = [title ?? "", viewModel?.event.value?.description ?? ""] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @objc func mapsButtonClicked(sender: AnyObject) {
        guard let lat = viewModel?.event.value?.latitude else { return }
        guard let lon = viewModel?.event.value?.longitude else { return }
        let url = URL(string: "maps://?q=Title&ll=\(lat),\(lon)")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    private func createTitle(_ title: String) -> String {
        let elements = title.split(separator: " ")
        guard elements.count > 3 else {
            return title
        }
        
        return "\(elements[0]) \(elements[1]) \(elements[2])"
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        view.addSubview(scrollView)
        view.addSubview(sharedFloatingButton)
        view.addSubview(mapsFloatingButton)
        scrollView.addSubview(dataLabel)
        scrollView.addSubview(priceLabel)
        scrollView.addSubview(descriptionLabel)
        
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12.0).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12.0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        scrollView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12.0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12.0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: sharedFloatingButton.topAnchor, constant: -10.0).isActive = true
        
        dataLabel.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        dataLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12.0).isActive = true
        dataLabel.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -12.0).isActive = true
        dataLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        
        priceLabel.topAnchor.constraint(equalTo: dataLabel.bottomAnchor, constant: 2.0).isActive = true
        priceLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12.0).isActive = true
        priceLabel.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -12.0).isActive = true
        priceLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 12.0).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12.0).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -12.0).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -12.0).isActive = true
        
        sharedFloatingButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sharedFloatingButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sharedFloatingButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        sharedFloatingButton.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
        
        mapsFloatingButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        mapsFloatingButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        mapsFloatingButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        mapsFloatingButton.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
    }
}

extension EventDetailsViewController: LoadUIImageViewDelegate {
    func fullDownloadImage(dictionary: [String : UIImage]) {}
}
