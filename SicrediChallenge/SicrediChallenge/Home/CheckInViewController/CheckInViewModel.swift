//
//  CheckInViewModel.swift
//  SicrediChallenge
//
//  Created by Diego Rodrigues Abdala Uthman on 06/03/22.
//

import UIKit
import RxCocoa
import RxSwift

class CheckInViewModel {
    
    let idEvent: String
    let service = EventService()
    let name = BehaviorRelay<String>(value: "")
    let email = BehaviorRelay<String>(value: "")
    let success = PublishSubject<Void>()
    let error = PublishSubject<Error>()
    
    init(idEvent: String) {
        self.idEvent = idEvent
    }
    
    func checkIn() {
        let checkIn = CheckIn(idEvent: idEvent, name: name.value, email: email.value)
        service.checkIn(checkIn: checkIn) {[success,error] response in
            guard let _ = response else {
                success.onNext(())
                return
            }
            error.onError(NSError(domain: "Não foi possível fazer o check-in, tente novamente mais tarde!", code: 500))
        }
    }
}
