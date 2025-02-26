//
//  ShoppingTitleViewModel.swift
//  SeSacHW16
//
//  Created by 변정훈 on 2/6/25.
//

import Foundation
import RxSwift
import RxCocoa

class ShoppingTitleViewModel {
    
    struct Input {
        let searchBarTapped: ControlEvent<Void>
        
        let searchBarText: ControlProperty<String>
        
        let rightBarButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let placeHolderText: PublishRelay<String>
        
        let validation: BehaviorRelay<Bool>
    }
    
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let placeHolderText = PublishRelay<String>()
        
        let validation = BehaviorRelay(value: true)
        
        input.searchBarTapped
            .withLatestFrom(input.searchBarText)
            .map { $0.count < 2 ? "2글자 이상 입력해주세요" : $0}
            .bind(with: self) { owner, value in
                placeHolderText.accept(value)
            }
            .disposed(by: disposeBag)
           
        
        input.searchBarText
            .map { $0.count >= 2 }
            .bind(to: validation)
            .disposed(by: disposeBag)
        
        
        return Output(placeHolderText: placeHolderText, validation: validation)
    }
}
