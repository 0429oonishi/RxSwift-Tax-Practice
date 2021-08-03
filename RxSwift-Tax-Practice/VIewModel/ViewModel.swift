//
//  ViewModel.swift
//  RxSwift-Tax-Practice
//
//  Created by 大西玲音 on 2021/08/03.
//

import RxSwift
import RxCocoa

protocol ViewModelInput {
    func calculateButtonDidTapped(excludingTaxText: String?,
                                  consumptionTaxText: String?)
    func viewDidLoad()
}

protocol ViewModelOutput: AnyObject {
    var includingTaxText: Driver<String> { get }
    var consumptionTaxText: Driver<String> { get }
}

protocol ViewModelType {
    var inputs: ViewModelInput { get }
    var outputs: ViewModelOutput { get }
}

final class ViewModel: ViewModelInput, ViewModelOutput {
    
    private let taxUseCase = TaxUseCase(
        repository: TaxRepository(
            dataStore: TaxUserDefaultsDataStore()
        )
    )
    var includingTaxText: Driver<String> {
        includingTaxTextRelay.asDriver(onErrorDriveWith: .empty())
    }
    private let includingTaxTextRelay = PublishRelay<String>()
    var consumptionTaxText: Driver<String> {
        consumptionTaxTextRelay.asDriver(onErrorDriveWith: .empty())
    }
    private let consumptionTaxTextRelay = PublishRelay<String>()
    private let disposeBag = DisposeBag()
    
    func viewDidLoad() {
        setupBindings()
        taxUseCase.loadConsumptionTax()
    }
    
    func calculateButtonDidTapped(excludingTaxText: String?,
                                  consumptionTaxText: String?) {
        let excludingTax = Int(excludingTaxText ?? "") ?? 0
        let consumptionTax = Int(consumptionTaxText ?? "") ?? 0
        taxUseCase.saveTax(consumptionTax: consumptionTax)
        taxUseCase.calculateIncludingTax(excludingTax: excludingTax,
                                         consumptionTax: consumptionTax)
    }
    
    // UseCaseからの出力を適切に変換してViewへ流す
    private func setupBindings() {
        taxUseCase.includingTax // Observable<Int?>
            .compactMap { $0 } // Observable<Int>
            .map { String($0) } // Observable<String>
            .bind(to: includingTaxTextRelay)
            .disposed(by: disposeBag)
        
        taxUseCase.consumptionTax
            .compactMap { $0 }
            .map { String($0) }
            .bind(to: consumptionTaxTextRelay)
            .disposed(by: disposeBag)
    }
    
}

extension ViewModel: ViewModelType {
    
    var inputs: ViewModelInput {
        return self
    }
    
    var outputs: ViewModelOutput {
        return self
    }
    
}
