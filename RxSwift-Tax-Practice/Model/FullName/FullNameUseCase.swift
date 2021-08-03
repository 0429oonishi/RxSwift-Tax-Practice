//
//  FullNameUseCase.swift
//  Pods
//
//  Created by 大西玲音 on 2021/08/03.
//

import Foundation
import RxSwift
import RxRelay

final class FullNameUseCase {
    
    private let repository: FullNameRepositoryProtocol
    init(repository: FullNameRepositoryProtocol) {
        self.repository = repository
        setupBindings()
    }
    private let disposeBag = DisposeBag()

    private let saveFullNameTrigger = PublishRelay<String>()
    private let loadFullNameTrigger = PublishRelay<Void>()

    var fullNameText: Observable<String?> {
        fullNameTextRelay.asObservable()
    }
    private let fullNameTextRelay = BehaviorRelay<String?>(value: nil)
    
    func loadFullName() {
        loadFullNameTrigger.accept(())
    }
    
    func createFullName(lastNameText: String?, firstNameText: String?) {
        guard let lastNameText = lastNameText,
              let firstNameText = firstNameText else { return }
        let fullName = lastNameText + firstNameText
        fullNameTextRelay.accept(fullName)
        saveFullNameTrigger.accept(fullName)
    }

    private func setupBindings() {
        saveFullNameTrigger
            .flatMapLatest(repository.saveFullName(text:))
            .subscribe()
            .disposed(by: disposeBag)
        
        loadFullNameTrigger
            .flatMapLatest(repository.loadFullName)
            .bind(to: fullNameTextRelay)
            .disposed(by: disposeBag)
    }
    
}
