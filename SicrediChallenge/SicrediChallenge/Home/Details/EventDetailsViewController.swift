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
    
    lazy var descriptionLabel: UILabel = {
        $0.font = UIFont(name: "Courier Regular", size: 15)
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.sizeToFit()
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    lazy var imageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
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
                self.imageView.setDownloadImage(url: event.image, self)
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
        scrollView.addSubview(descriptionLabel)
        
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12.0).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12.0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        scrollView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12.0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12.0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 12.0).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12.0).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -12.0).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -12.0).isActive = true
    }
}

extension EventDetailsViewController: LoadUIImageViewDelegate {
    func fullDownloadImage(dictionary: [String : UIImage]) {}
}
