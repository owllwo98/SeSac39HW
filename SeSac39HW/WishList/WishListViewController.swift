//
//  WishListViewController.swift
//  SeSac39HW
//
//  Created by 변정훈 on 2/26/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit



struct Product: Hashable, Identifiable {
    let id = UUID()
    
    let name: String
    let date: String
}

class WishListViewController: UIViewController {
    
    enum Section: CaseIterable {
        case main
    }
    
    let disposeBag = DisposeBag()
    
    lazy var wishListSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchTextField.textColor = .white
        searchBar.barTintColor = .black
        
        return searchBar
    }()
    
    lazy var wishListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Product>!
    
    var wishList: [Product] = [Product(name: "고래밥", date: Date().formatted())]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        
        wishListCollectionView.delegate = self
        
        configureHierarchy()
        configureLayout()
        
        configureDataSource()
        updateSnapShot()
        
        bind()
    }
    
    deinit {
        print("deinit!")
    }
    
    func bind() {
        wishListSearchBar.rx.searchButtonClicked
            .withLatestFrom(wishListSearchBar.rx.text.orEmpty)
            .bind(with: self) { owner, value in
                let product = Product(name: value, date: Date().formatted())
                owner.wishList.append(product)
                
                owner.updateSnapShot()
            }
            .disposed(by: disposeBag)
    }
    

    private func configureHierarchy() {
        view.addSubview(wishListSearchBar)
        view.addSubview(wishListCollectionView)
    }
    
    private func configureLayout() {
        wishListSearchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        
        wishListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(wishListSearchBar.snp.bottom).inset(-4)
            make.width.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureView() {
        navigationItem.title = "Wish List"
    }

}

extension WishListViewController {
    private func configureDataSource() {
        let registraion = UICollectionView.CellRegistration<UICollectionViewCell, Product> { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            
            content.text = itemIdentifier.name
            content.textProperties.color = .white
            content.textProperties.font = .systemFont(ofSize: 12, weight: .bold)
            
            content.secondaryText = itemIdentifier.date
            content.secondaryTextProperties.font = .systemFont(ofSize: 12, weight: .bold)
            content.secondaryTextProperties.color = .white
            
            cell.contentConfiguration = content
            
            var backGroundConfig = UIBackgroundConfiguration.listGroupedCell()
            
            backGroundConfig.backgroundColor = .black
            backGroundConfig.cornerRadius = 15
            backGroundConfig.strokeColor = .white
            backGroundConfig.strokeWidth = 2
            
            cell.backgroundConfiguration = backGroundConfig
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: wishListCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: registraion, for: indexPath, item: itemIdentifier)
            
            return cell
            
        })
    }
    
    
    private func updateSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Product>()
        
        snapShot.appendSections(Section.allCases)
        
        snapShot.appendItems(wishList, toSection: .main)
        
        dataSource.apply(snapShot)
    }
}

extension WishListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data = dataSource.itemIdentifier(for: indexPath)
        
        wishList.remove(at: indexPath.item)
    
        updateSnapShot()
    }
}

extension WishListViewController {
    private func createLayout() -> UICollectionViewLayout {
        
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        
        configuration.showsSeparators = true
        configuration.separatorConfiguration.color = .white
        configuration.backgroundColor = .black
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        return layout
    }
}
