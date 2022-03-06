//
//  DetailViewModel.swift
//  SicrediChallenge
//
//  Created by Diego Rodrigues Abdala Uthman on 06/03/22.
//

import UIKit
import RxCocoa
import RxSwift

class EventDetailViewModel {
    
    let service = EventService()
    let idEvent: String
    var event = BehaviorRelay<Event?>(value: nil)
    var error = BehaviorRelay<Error?>(value: nil)
    
    init(idEvent: String){
        self.idEvent = idEvent
    }
    
    func fetchEventById() {
        service.fetchEventById(id: idEvent) { [event, error] response in
            switch response {
            case .success(let eventResponse):
                event.accept(eventResponse)
                break
            case .failure(let failure):
                error.accept(failure)
                break
            }
        }
    }
}
