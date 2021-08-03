//
//  FullNameViewModel.swift
//  RxSwift-Tax-Practice
//
//  Created by 大西玲音 on 2021/08/03.
//

import Foundation
import RxSwift
import RxCocoa

protocol FullNameViewModelInput {
    func plusButtonDidTapped(lastNameText: String?,
                             firstNameText: String?)
    func viewDidLoad()
}

protocol FullNameViewModelOutput: AnyObject {
    var fullNameText: Driver<String> { get }
}

protocol FullNameViewModelType {
    var inputs: FullNameViewModelInput { get }
    var outputs: FullNameViewModelOutput { get }
}

final class FullNameViewModel: FullNameViewModelInput,
                               FullNameViewModelOutput {
    private let fullNameUseCase = FullNameUseCase(
        repository: FullNameRepository()
    )
    private let disposeBag = DisposeBag()
    
    func plusButtonDidTapped(lastNameText: String?,
                             firstNameText: String?) {
        fullNameUseCase.createFullName(lastNameText: lastNameText,
                                       firstNameText: firstNameText)
    }
    
    var fullNameText: Driver<String> {
        fullNameTextRelay.asDriver()
    }
    private let fullNameTextRelay = BehaviorRelay<String>(value: "フルネーム")
    
    func viewDidLoad() {
        setupBindings()
        fullNameUseCase.loadFullName()
    }
    
    private func setupBindings() {
        fullNameUseCase.fullNameText
            .compactMap { $0 }
            .bind(to: fullNameTextRelay)
            .disposed(by: disposeBag)
    }
    
}

extension FullNameViewModel: FullNameViewModelType {
    
    var inputs: FullNameViewModelInput {
        return self
    }
    
    var outputs: FullNameViewModelOutput {
        return self
    }
    
}
