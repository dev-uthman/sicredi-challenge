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
        eventColletionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        eventColletionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        eventColletionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        eventColletionView.heightAnchor.constraint(lessThanOrEqualToConstant: 200).isActive = true
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

extension HomeViewController: UICollectionViewDelegate {}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.events.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = eventColletionView.dequeueReusableCell(withReuseIdentifier: EventCollectionViewCell.reuseIdentifier, for: indexPath) as? EventCollectionViewCell {
            cell.delegate = self
            
            guard let imageUrl = viewModel.events.value?[indexPath.row].image else { return cell }
            
            if viewModel.hasImage(imageUrl) {
                cell.configImage(image: viewModel.loadCacheImage(imageUrl))
            } else {
                cell.configImage(urlImage: imageUrl)
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

extension HomeViewController: LoadUIImageViewDelegate {
    func fullDownloadImage(dictionary: [String : UIImage]) {
        guard let key = dictionary.keys.first else { return }
        guard let value = dictionary.values.first else { return }
        viewModel.saveCache(key,value)
    }
}