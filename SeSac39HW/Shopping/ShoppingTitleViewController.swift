//
//  ShoppingTitleViewController.swift
//  SeSacHW16
//
//  Created by 변정훈 on 1/15/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RealmSwift

class ShoppingTitleViewController: UIViewController {
    lazy var shoppingSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchTextField.textColor = .white
        searchBar.barTintColor = .black
        
        return searchBar
    }()
    
    let posterImageView: UIImageView = UIImageView()
    
    let viewModel = ShoppingTitleViewModel()
    
    var productList: Results<ProductTable>!
    
    let realm = try! Realm()
    let folderRepository: FolderRepository = FolderTableRepository()
    let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureLayout()
        configureView()
        
        bindData()
        
        productList = realm.objects(ProductTable.self)
        
        print(realm.configuration.fileURL)
//        folderRepository.createItem(name: "프랑스")
//        folderRepository.createItem(name: "영국")
//        folderRepository.createItem(name: "이탈리아")
//        folderRepository.createItem(name: "크로아티아")

    }
    
    
    func bindData() {
        
        let input = ShoppingTitleViewModel.Input(searchBarTapped: shoppingSearchBar.rx.searchButtonClicked, searchBarText: shoppingSearchBar.rx.text.orEmpty, rightBarButtonTapped: navigationItem.rightBarButtonItem?.rx.tap ?? ControlEvent(events: Observable.empty()))
        
        let output = viewModel.transform(input: input)
        
        output.placeHolderText
            .bind(to: shoppingSearchBar.rx.text)
            .disposed(by: disposebag)
        
        shoppingSearchBar.rx.searchButtonClicked
            .withLatestFrom(output.validation)
            .filter { $0 }
            .withLatestFrom(output.placeHolderText)
            .bind(with: self) { owner, value in
                let vc = ShoppingDetailViewController()
                
                vc.query.accept(value)
                
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposebag)
    
        navigationItem.rightBarButtonItem?.rx.tap
            .bind(with: self, onNext: { owner, _ in
//                let vc = WishListViewController()
                let vc = FolderViewController()
                
                owner.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposebag)
        
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(with: self, onNext: { owner, _ in
                let vc = LikeViewController()
                
                owner.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposebag)
        
    }
    
    func configureHierarchy() {
        view.addSubview(shoppingSearchBar)
        view.addSubview(posterImageView)
    }
    
    func configureLayout() {
        shoppingSearchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.top.equalTo(shoppingSearchBar.snp.bottom).inset(-120)
            make.width.equalTo(300)
            make.height.equalTo(230)
            make.centerX.equalToSuperview()
        }
        
    }
    
    func configureView() {
        view.backgroundColor = .black
        self.navigationItem.title = "도봉러의 쇼핑쇼핑"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: nil, action: nil)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "back"), style: .plain, target: self, action: nil)
        navigationController?.navigationBar.tintColor = .lightGray
        
        shoppingSearchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "브랜드, 상품, 프로필, 태그 등", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0.51, green: 0.51, blue: 0.537, alpha: 1)])
       
        posterImageView.image = UIImage(named: "poster")
    }

}
