//
//  FullNameRepository.swift
//  RxSwift-Tax-Practice
//
//  Created by 大西玲音 on 2021/08/03.
//

import Foundation
import RxSwift

protocol FullNameRepositoryProtocol {
    func saveFullName(text: String) -> Completable
    func loadFullName() -> Single<String?>
}

final class FullNameRepository: FullNameRepositoryProtocol {
    
    private let dataStore = FullNameDataStore()
    
    func saveFullName(text: String) -> Completable {
        dataStore.saveFullName(text: text)
        return Completable.empty()
    }
    
    func loadFullName() -> Single<String?> {
        return .just(dataStore.loadFullName())
    }
    
}
