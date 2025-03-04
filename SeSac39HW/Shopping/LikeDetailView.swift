//
//  LikeDetailView.swift
//  SeSac39HW
//
//  Created by 변정훈 on 3/4/25.
//

import UIKit
import SnapKit

class LikeDetailView: BaseView {
    
    let likeSearchBar: UISearchBar = {
        let search = UISearchBar()
        search.backgroundColor = .black
        search.searchTextField.backgroundColor = .gray
        search.tintColor = .white
        search.placeholder = "상품을 검색해보세요"
        search.barTintColor = .black
        search.searchTextField.textColor = .white
        
        return search
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2 - 16, height: UIScreen.main.bounds.width / 2 + 30)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.minimumLineSpacing = 35
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    override func configureHierarchy() {
        [likeSearchBar, collectionView].forEach {
            addSubview($0)
        }
    }
    
    override func configureLayout() {
        likeSearchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(8)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(likeSearchBar.snp.bottom).inset(-8)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        backgroundColor = .black
      
    }
    
   
}
