//
//  FullNameViewController.swift
//  RxSwift-Tax-Practice
//
//  Created by 大西玲音 on 2021/08/03.
//

import UIKit
import RxSwift
import RxCocoa

final class FullNameViewController: UIViewController {
    
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var plusButton: UIButton!
    @IBOutlet private weak var fullNameLabel: UILabel!
    
    private let viewModel: FullNameViewModelType = FullNameViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        viewModel.inputs.viewDidLoad()
        
    }
    
    private func setupBindings() {
        plusButton.rx.tap
            .withLatestFrom(lastNameTextField.rx.text)
            .withLatestFrom(firstNameTextField.rx.text,
                            resultSelector: { ($0, $1) })
            .subscribe(onNext: viewModel.inputs.plusButtonDidTapped)
            .disposed(by: disposeBag)
        
        viewModel.outputs.fullNameText
            .drive(fullNameLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
}
