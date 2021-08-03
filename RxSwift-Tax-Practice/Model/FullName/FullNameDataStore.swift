//
//  FullNameDataStore.swift
//  RxSwift-Tax-Practice
//
//  Created by 大西玲音 on 2021/08/03.
//

import Foundation

final class FullNameDataStore {
    
    private let key = "sampleKey"
    
    func saveFullName(text: String) {
        UserDefaults.standard.set(text, forKey: key)
    }
    
    func loadFullName() -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
}
