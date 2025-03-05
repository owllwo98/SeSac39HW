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
import RealmSwift

class WishListViewController: UIViewController {
    
    enum Section: CaseIterable {
        case main
    }
    
    var list: List<TravelTable>!
    var id: ObjectId!
    
    let repository: TravelRepository = TravelTableRepository()
    let folderRepository: FolderRepository = FolderTableRepository()
    
    let disposeBag = DisposeBag()
    
    lazy var wishListSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchTextField.textColor = .white
        searchBar.barTintColor = .black
        return searchBar
    }()
    
    lazy var wishListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    var dataSource: UICollectionViewDiffableDataSource<Section, TravelTable>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        wishListCollectionView.delegate = self
        
        configureHierarchy()
        configureLayout()
        
        configureDataSource()
        
        updateSnapShot()
        
        bind()
        
        navigationItem.title = list.first?.folder.first?.name
    }
    
    deinit {
        print("deinit!")
    }
    
    func bind() {
        wishListSearchBar.rx.searchButtonClicked
            .withLatestFrom(wishListSearchBar.rx.text.orEmpty)
            .bind(with: self) { owner, value in
                
                guard let folder = owner.folderRepository.fetchAll().where({ $0.id == owner.id }).first else { return }
                
      
                owner.repository.createItemInFolder(folder: folder, city: value)
                              
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
}

extension WishListViewController {
    private func configureDataSource() {
        let registration = UICollectionView.CellRegistration<UICollectionViewCell, TravelTable> { cell, indexPath, item in
            
            var content = UIListContentConfiguration.valueCell()
            content.text = item.city 
            content.textProperties.color = .white
            content.textProperties.font = .systemFont(ofSize: 12, weight: .bold)
            
            cell.contentConfiguration = content
            
            var backgroundConfig = UIBackgroundConfiguration.listGroupedCell()
            backgroundConfig.backgroundColor = .black
            backgroundConfig.cornerRadius = 15
            backgroundConfig.strokeColor = .white
            backgroundConfig.strokeWidth = 2
            
            cell.backgroundConfiguration = backgroundConfig
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: wishListCollectionView, cellProvider: { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: item)
        })
    }
    
    private func updateSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, TravelTable>()
        snapShot.appendSections([.main])
        snapShot.appendItems(Array(list)) 
        dataSource.apply(snapShot)
    }
}

extension WishListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
//        
//        
//        updateSnapShot()
    }
}

extension WishListViewController {
    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.showsSeparators = true
        configuration.separatorConfiguration.color = .white
        configuration.backgroundColor = .black
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
}
