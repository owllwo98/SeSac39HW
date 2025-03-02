//
//  ShoppingDetailViewModel.swift
//  SeSacHW16
//
//  Created by 변정훈 on 2/6/25.
//

import Foundation
import RxSwift
import RxCocoa

class ShoppingDetailViewModel {
    
    struct Input {
        let query: BehaviorRelay<String>
        
        let similarButtonTapped: ControlEvent<Void>
        let dateButtonTapped: ControlEvent<Void>
        let dscButtonTapped: ControlEvent<Void>
        let ascButtonTapped: ControlEvent<Void>
        
        let indexPaths: ControlEvent<[IndexPath]>
    }
    
    struct Output {
        let shoppingData: BehaviorRelay<Shopping>
        
        let selectButton: BehaviorRelay<Int>
        
        let responseError: BehaviorRelay<APIError?>
        
        let scrollTop: PublishRelay<Bool>
    }
    
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
//        let shoppingData = PublishRelay<Shopping>()
        let shoppingData = BehaviorRelay(value: Shopping(items: [], total: 0))
        
        let selectButton = BehaviorRelay(value: 0)
        
        let responseError = BehaviorRelay<APIError?>(value: nil)
        
        let startTrigger = PublishRelay<Void>()
        
        let sortType = BehaviorRelay(value: "")
        
        let start = BehaviorRelay(value: 1)
        
        let scrollTop = PublishRelay<Bool>()
        
        input.similarButtonTapped
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .withLatestFrom(input.query)
            .flatMap {
                NetworkManager.shared.requestShoppingData(query: $0, start: 1, sort: "sim")
                    .do(onDispose: { print("sim dispose") })
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let shopping):
                    
                    shoppingData.accept(shopping)
                    selectButton.accept(0)
                    sortType.accept("sim")
                    start.accept(1)
                case .failure(let error):
//                    dump(error)
                    responseError.accept(error)
                    print("")
                }
            }
            .disposed(by: disposeBag)
        
        
        input.dateButtonTapped
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .withLatestFrom(input.query)
            .flatMap {
                NetworkManager.shared.requestShoppingData(query: $0, start: 1, sort: "date")
                    .do(onDispose: { print("date dispose") })
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let shopping):
                    
                    shoppingData.accept(shopping)
                    selectButton.accept(1)
                    sortType.accept("date")
                    start.accept(1)
                case .failure(let error):
//                    dump(error)
                    responseError.accept(error)
                    print("")
                    
                }
            }
            .disposed(by: disposeBag)
        
        input.dscButtonTapped
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .withLatestFrom(input.query)
            .flatMap {
                NetworkManager.shared.requestShoppingData(query: $0, start: 1, sort: "dsc")
                    .do(onDispose: { print("dsc dispose") })
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let shopping):
                    
                    shoppingData.accept(shopping)
                    selectButton.accept(2)
                    sortType.accept("dsc")
                    start.accept(1)
                case .failure(let error):
//                    dump(error)
                    responseError.accept(error)
                    print("")
                }
            }
            .disposed(by: disposeBag)
        
        input.ascButtonTapped
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .withLatestFrom(input.query)
            .flatMap {
                NetworkManager.shared.requestShoppingData(query: $0, start: 1, sort: "asc")
                    .do(onDispose: { print("asc dispose") })
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let shopping):
                    
                    shoppingData.accept(shopping)
                    selectButton.accept(3)
                    sortType.accept("asc")
                    start.accept(1)
                case .failure(let error):
//                    dump(error)
                    responseError.accept(error)
                    print("")
                }
            }
            .disposed(by: disposeBag)
        
        input.query
            .flatMap {
                NetworkManager.shared.requestShoppingData(query: $0, start: 1, sort: "sim")
                    .do(onDispose: { print("sim dispose") })
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let shopping):
                    
                    shoppingData.accept(shopping)
                    sortType.accept("sim")
                case .failure(let error):
//                    dump(error)
                    responseError.accept(error)
                    print("")
                }
            }
            .disposed(by: disposeBag)
        
        
        Observable
            .combineLatest(input.indexPaths, shoppingData)
            .bind(with: self) { owner, zipData in
                for item in zipData.0 {
                    if (zipData.1.items.count) - 2 == item.item {
                        let newValue = start.value + 30
                        start.accept(newValue)
                        startTrigger.accept(())
                    }
                }
            }
            .disposed(by: disposeBag)
        
        startTrigger
            .withLatestFrom(input.query)
            .flatMap {
                NetworkManager.shared.requestShoppingData(query: $0, start: start.value, sort: sortType.value)
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let shopping):
                    var currentData = shoppingData.value
                    currentData.items.append(contentsOf: shopping.items)
                    
                    shoppingData.accept(currentData)
                case .failure(let error):
                    dump(error)
                    responseError.accept(error)
                }
            }
            .disposed(by: disposeBag)
        
        start
            .map { $0 == 1 }
            .bind(to: scrollTop)
            .disposed(by: disposeBag)
        
        return Output(shoppingData: shoppingData, selectButton: selectButton, responseError: responseError, scrollTop: scrollTop)
    }
    
}
