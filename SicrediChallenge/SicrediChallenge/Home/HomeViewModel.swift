//
//  HomeVIewModel.swift
//  SicrediChallenge
//
//  Created by Diego Rodrigues Abdala Uthman on 05/03/22.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewModel {

    private let service = HomeService()
    private var imageCache:[String:UIImage] = [:]
    
    var events = BehaviorRelay<[Event]?>(value: nil)
    var error = PublishSubject<Error?>()
    
    internal func fetchEvents() {
        service.fetchEvent { [events, error] response in
            switch response {
            case .success(let eventsArray):
                events.accept(eventsArray)
            case .failure(let errorResponse):
                error.onError(errorResponse)
            }
        }
    }
    
    internal func loadCacheImage(_ url: String) -> UIImage {
        return imageCache[url] ?? UIImage()
    }
    
    internal func saveCache(_ url:String, _ image:UIImage) {
        guard hasImage(url) else{
            imageCache[url] = image
            return
        }
    }
    
    internal func hasImage(_ url:String) -> Bool {
        return imageCache[url] != nil
    }
}
