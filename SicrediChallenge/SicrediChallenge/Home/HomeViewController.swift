//
//  HomeViewController.swift
//  SicrediChallenge
//
//  Created by Diego Rodrigues Abdala Uthman on 05/03/22.
//

import UIKit
import RxSwift

class HomeViewController: BaseViewController {
    
    let viewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    let eventColletionView = EventCollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchData()
        setupUI()
        bindRx()
    }
    
    private func fetchData() {
        addLoading()
        viewModel.fetchEvents()
    }
    
    private func setupUI(){
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        view.addSubview(eventColletionView)
        eventColletionView.delegate = self
        eventColletionView.dataSource = self
        eventColletionView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        eventColletionView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        eventColletionView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        eventColletionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        eventColletionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        eventColletionView.heightAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        eventColletionView.isPagingEnabled = true
    }
    
    private func bindRx() {
        viewModel
            .events
            .observe(on: MainScheduler.asyncInstance)
            .filter{ $0 != nil }
            .subscribe(onNext: {[eventColletionView, hideLoading] events in
                eventColletionView.reloadData()
                hideLoading()
            }).disposed(by: disposeBag)
        
        viewModel
            .error
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onError: {[weak self] events in
                
            }).disposed(by: disposeBag)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let event = viewModel.events.value?[indexPath.row] {
            let viewModel = EventDetailViewModel(idEvent: event.id)
            let vc = EventDetailsViewController(viewModel: viewModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.events.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = eventColletionView.dequeueReusableCell(withReuseIdentifier: EventCollectionViewCell.reuseIdentifier, for: indexPath) as? EventCollectionViewCell {
            cell.delegate = self
            
            guard let imageUrl = viewModel.events.value?[indexPath.row].image else { return cell }
            let textTitle = viewModel.events.value?[indexPath.row].title ?? ""
            if viewModel.hasImage(imageUrl) {
                cell.configImage(image: viewModel.loadCacheImage(imageUrl), title: textTitle)
            } else {
                cell.configImage(urlImage: imageUrl, title: textTitle)
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frameSize = collectionView.frame.size
        return CGSize(width: frameSize.width - 10, height: frameSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
}

extension HomeViewController: LoadUIImageViewDelegate {
    func fullDownloadImage(dictionary: [String : UIImage]) {
        guard let key = dictionary.keys.first else { return }
        guard let value = dictionary.values.first else { return }
        viewModel.saveCache(key,value)
    }
}
