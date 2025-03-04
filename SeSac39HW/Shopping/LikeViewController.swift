//
//  LikeViewController.swift
//  SeSac39HW
//
//  Created by 변정훈 on 3/4/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RealmSwift
import Toast

class LikeViewController: UIViewController {
    
    var likeDetailView = LikeDetailView()
    
    var productList: Results<ProductTable>!
    
    let realm = try! Realm()
    
    lazy var collectionViewList = BehaviorRelay(value: realm.objects(ProductTable.self))
    
    let listChaged = PublishRelay<Void>()
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = likeDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        likeDetailView.collectionView.register(ShoppingDetailCollectionViewCell.self, forCellWithReuseIdentifier: "ShoppingDetailCollectionViewCell")
        
        productList = realm.objects(ProductTable.self)
        
        bind()
        
    }
    
    func bind() {
        collectionViewList
            .bind(to: likeDetailView.collectionView.rx.items(cellIdentifier: ShoppingDetailCollectionViewCell.id, cellType: ShoppingDetailCollectionViewCell.self)) {  (row, element, cell) in
                
                cell.configureData2(element)
                cell.configureHeart(element.productlike)
                
                cell.likeButton.rx.tap
                    .do(onDispose: { print("cell dispose!") })
                    .bind(with: self) { owner, _ in
                        if element.productlike {
                            do {
                                try owner.realm.write {
                                    
                                    owner.realm.delete(element)
                                    owner.listChaged.accept(())
                                    owner.view.makeToast("Product 삭제 성공!", duration: 2.0)
                                    
                                    print("realm 에 삭제 성공!")
                                }
                            } catch {
                                print("realm 에 삭제 실패!")
                            }
                        } else {
                           
                        }
                    }
                    .disposed(by: cell.disposeBag)
                
                DispatchQueue.main.async {
                    cell.itemImageView.layer.cornerRadius = 10
                    cell.itemImageView.clipsToBounds = true
                }
            }
            .disposed(by: disposeBag)
        
        likeDetailView.likeSearchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(with: self) { owner, value in
                let data = owner.productList
                    .where { $0.title.contains(value, options: .caseInsensitive) }
                value.count == 0 ? owner.collectionViewList.accept(owner.productList) :
                owner.collectionViewList.accept(data)
                print("asddsa")
            }
            .disposed(by: disposeBag)
        
        listChaged
            .bind(with: self) { owner, _ in
                owner.collectionViewList.accept(owner.productList)
            }
            .disposed(by: disposeBag)
    }
    

}
