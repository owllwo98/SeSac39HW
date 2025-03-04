//
//  ShoppingDetailViewController.swift
//  SeSacHW16
//
//  Created by 변정훈 on 1/15/25.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import SnapKit
import Kingfisher
import RealmSwift

class ShoppingDetailViewController: UIViewController {
    
    var shoppingDetailView = ShoppingDetailView()
    
    let viewModel = ShoppingDetailViewModel()
    
    let disposeBag = DisposeBag()
    
    let query = BehaviorRelay<String>(value: "")
    
    var productList: Results<ProductTable>!
    
    let realm = try! Realm()
    
    
    
    override func loadView() {
        self.view = shoppingDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productList = realm.objects(ProductTable.self)
        
        configureView()
    
        bindData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        dump(productList)
    }
    
    deinit {
        print("deinit!")
    }
    
    func bindData() {
        let input = ShoppingDetailViewModel.Input(query: query, similarButtonTapped: shoppingDetailView.standardButton.rx.tap, dateButtonTapped: shoppingDetailView.dateSortButton.rx.tap, dscButtonTapped: shoppingDetailView.highPriceSortButton.rx.tap, ascButtonTapped: shoppingDetailView.lowPriceSortButton.rx.tap, indexPaths: shoppingDetailView.collectionView.rx.prefetchItems)
        
        let output = viewModel.transform(input: input)
        
        output.shoppingData
            .map {$0.items}
            .bind(to: shoppingDetailView.collectionView.rx.items(cellIdentifier: ShoppingDetailCollectionViewCell.id, cellType: ShoppingDetailCollectionViewCell.self)) {  (row, element, cell) in
                
                cell.configureData(element)
                cell.likeButton.tag = row
                
//                print(cell.likeButton.tag)
                
                

                
                cell.likeButton.rx.tap
                    .do(onDispose: { print("cell dispose!") })
                    .bind(with: self) { owner, _ in
                        
                        if self.productList.contains(where: {
                            $0.id == cell.cellID
                        }) {
                            do {
                                try owner.realm.write {
                                    let data = owner.productList.filter {
                                        $0.id == cell.cellID
                                    }
                                    owner.realm.delete(data)
                                    
                                    print("realm 에 삭제 성공!")
                                }
                            } catch {
                                print("realm 에 삭제 실패!")
                            }
                        } else {
                            do {
                                try owner.realm.write {
              
                                    let data = ProductTable(itemImage: element.image, mallName: element.mallName, title: element.title, lprice: element.lprice, productlike: true)
                                    
                                    owner.realm.add(data)
                                    cell.id(id: data.id)
                                    print("realm 저장완료")
                                }
                                
                                owner.productList = owner.realm.objects(ProductTable.self)
                            } catch {
                                print("realm 에 저장 실패!")
                            }
                        }
                    }
                    .disposed(by: cell.disposeBag)
                
                DispatchQueue.main.async {
                    cell.itemImageView.layer.cornerRadius = 10
                    cell.itemImageView.clipsToBounds = true
                }
            }
            .disposed(by: disposeBag)
        
//        shoppingDetailView.collectionView.rx.itemSelected
//            .bind(with: self) { owenr, value in
//                print(value)
//            }
//            .disposed(by: disposeBag)
        
        output.shoppingData
            .map { "\($0.total ?? 0) 개의 검색 결과" }
            .bind(to: shoppingDetailView.totalLabel.rx.text)
            .disposed(by: disposeBag)
        
        query
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        output.selectButton
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, value in
                [owner.shoppingDetailView.standardButton,
                 owner.shoppingDetailView.dateSortButton,
                 owner.shoppingDetailView.highPriceSortButton,
                 owner.shoppingDetailView.lowPriceSortButton].forEach {
                    if $0.tag == value {
                        $0.backgroundColor = .white
                        $0.setTitleColor(.black, for: .normal)
                    } else {
                        $0.backgroundColor = .black
                        $0.setTitleColor(.white, for: .normal)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        output.responseError
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, error in
                guard let error else {
                    return
                }
                owner.present(UIViewController.customAlert(errorMessage: error.errorMessage), animated: true)
            }
            .disposed(by: disposeBag)
        
        output.scrollTop
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, value in
                value ? owner.shoppingDetailView.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false) : ()
            }
            .disposed(by: disposeBag)
        
    }
    
    func configureView() {
        shoppingDetailView.collectionView.register(ShoppingDetailCollectionViewCell.self, forCellWithReuseIdentifier: "ShoppingDetailCollectionViewCell")
    }
    
}

extension UIViewController {
    static func customAlert(errorMessage: String) -> UIAlertController {
        let saveAlert = UIAlertController(title: "네트워크 오류 발생!", message: errorMessage , preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default) { action in
            
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { action in
            
        }
        
        saveAlert.addAction(okAction)
        saveAlert.addAction(cancelAction)

        return saveAlert
    }
}

