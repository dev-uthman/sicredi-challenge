//
//  CheckInViewController.swift
//  SicrediChallenge
//
//  Created by Diego Rodrigues Abdala Uthman on 06/03/22.
//

import UIKit
import RxSwift

class CheckInViewController: BaseViewController {
    
    let disposedBag = DisposeBag()
    
    lazy var nameLabel: UILabel = {
        $0.font = UIFont(name: "Courier Regular", size: 10)
        $0.textColor = .black
        $0.text = "Nome"
        $0.textAlignment = .center
        $0.sizeToFit()
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    lazy var emailLabel: UILabel = {
        $0.font = UIFont(name: "Courier Regular", size: 10)
        $0.textColor = .black
        $0.text = "Email"
        $0.textAlignment = .center
        $0.sizeToFit()
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    var nameTextField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.borderColor = UIColor.gray.cgColor.copy(alpha: 0.5)
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 5
        return $0
    }(UITextField())
    
    var emailTextField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.borderColor = UIColor.gray.cgColor.copy(alpha: 0.5)
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 5
        return $0
    }(UITextField())
    
    var buttonContinue: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Continuar", for: .normal)
        $0.setTitleColor(.blue, for: .normal)
        return $0
    }(UIButton())
    
    var viewModel: CheckInViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        title = "Check-In"
        view.backgroundColor = .white
        bindRx()
    }
    
    convenience init(viewModel: CheckInViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    private func setupUI() {
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(buttonContinue)
        
        nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        nameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
        nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
        nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        nameTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
        emailLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10).isActive = true
        emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        emailLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
        emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        emailTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
        buttonContinue.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20).isActive = true
        buttonContinue.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonContinue.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        buttonContinue.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        
        buttonContinue.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    @objc private func buttonAction() {
        self.addLoading()
        self.viewModel?.checkIn()
    }
    
    private func bindRx() {
        guard let viewModel = viewModel else { return }
        nameTextField
            .rx
            .controlEvent(.editingChanged)
            .asObservable()
            .subscribe(onNext: {[viewModel, nameTextField] in
                viewModel.name.accept(nameTextField.text ?? "")
            }).disposed(by: disposedBag)
        
        emailTextField
            .rx
            .controlEvent(.editingChanged)
            .asObservable()
            .subscribe(onNext: {[viewModel, emailTextField] in
                viewModel.email.accept(emailTextField.text ?? "")
            }).disposed(by: disposedBag)
        
        let nameValid = viewModel.name.asObservable()
            .map { $0.count > 0 }
            .share(replay: 1)
        
        let emailValid = viewModel.email.asObservable()
            .map { $0.count > 0 }
            .share(replay: 1)
        
        let allFieldsAreValid = Observable.combineLatest(nameValid, emailValid) { $0 && $1 }
            .share(replay: 1)
        
        allFieldsAreValid
            .bind(to: buttonContinue.rx.isEnabled)
            .disposed(by: disposedBag)
        
        viewModel
            .success
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.alert()
            }).disposed(by: disposedBag)
        
        viewModel
            .error
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onError: {[weak self] error in
                guard let self = self else { return }
                self.alert(error)
            }).disposed(by: disposedBag)
    }
    
    private func alert(_ error: Error? = nil) {
        let title: String
        let message: String
        
        if let error = error {
            title = "Ops"
            message = error.localizedDescription
        } else {
            title = "Check-in"
            message = "Check-in realizado com sucesso"
        }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in 
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: {
            self.hideLoading()
            
        })
    }
}
