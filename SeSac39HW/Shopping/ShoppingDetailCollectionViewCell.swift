//
//  ShoppingDetailCollectionViewCell.swift
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

class ShoppingDetailCollectionViewCell: UICollectionViewCell {
    
    static let id = "ShoppingDetailCollectionViewCell"
    
    let itemImageView: UIImageView = UIImageView()
    let mallName: UILabel = UILabel()
    let title: UILabel = UILabel()
    let lprice: UILabel = UILabel()
    let likeButton: UIButton = UIButton()
    
    var cellID: String? = nil
    
//    let realm = try! Realm()
    
//    var list: Results<JackTable>!
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureUI()
        configureLayout()
        
//        list = realm.objects(ProductTable.self)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        [itemImageView, mallName, title, lprice, likeButton].forEach {
            contentView.addSubview($0)
        }
        
//        itemImageView.addSubview(likeButton)
    }
    
    func configureUI() {
        
        mallName.textColor = .lightGray
        mallName.font = .systemFont(ofSize: 8, weight: .regular)
        
        title.textColor = .systemGray6
        title.font = .systemFont(ofSize: 8, weight: .regular)
        title.numberOfLines = 2
        
        lprice.textColor = .white
        lprice.font = .systemFont(ofSize: 12, weight: .regular)
        
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        
    }
    
    func configureLayout() {
        itemImageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(contentView.snp.width)
        }
        
//        likeButton.snp.makeConstraints { make in
//            make.bottom.equalToSuperview().inset(4)
//            make.trailing.equalToSuperview().inset(4)
//            make.size.equalTo(20)
//        }
        
        mallName.snp.makeConstraints { make in
            make.top.equalTo(itemImageView.snp.bottom).inset(-4)
            make.leading.equalToSuperview().inset(4)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(itemImageView.snp.bottom).inset(-4)
            make.trailing.equalToSuperview().inset(4)
            make.size.equalTo(20)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(mallName.snp.bottom).inset(-4)
            make.leading.equalToSuperview().inset(4)
            make.trailing.equalTo(likeButton.snp.leading).inset(-2)
        }
        
        lprice.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).inset(-4)
            make.leading.equalToSuperview().inset(4)
        }
    }
    
    func configureData(_ list: ShoppingDetail) {
        let url = URL(string: list.image ?? "star" + "?type=f50")
        itemImageView.kf.setImage(with: url)
        
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let patten = "<[^>]+>|&quot;|<b>|</b>"
        
        mallName.text = list.mallName
        title.text = list.title?.replacingOccurrences(of: patten,
                                                     with: "",
                                                     options: .regularExpression,
                                                     range: nil)
        lprice.text = numberFormatter.string(for: Int(list.lprice ?? "0"))
        
        cellID = list.productId
    }
    
    func configureHeart(_ like: Bool) {
        likeButton.setImage(UIImage(systemName: like ? "heart.fill" : "heart"), for: .normal)
    }
    
    func configureData2(_ list: ProductTable?) {
        guard let list else {
            return
        }
        
        let url = URL(string: list.itemImage ?? "star" + "?type=f50")
        itemImageView.kf.setImage(with: url)
        
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let patten = "<[^>]+>|&quot;|<b>|</b>"
        
        mallName.text = list.mallName
        title.text = list.title?.replacingOccurrences(of: patten,
                                                     with: "",
                                                     options: .regularExpression,
                                                     range: nil)
        lprice.text = numberFormatter.string(for: Int(list.lprice ?? "0"))
    }
 
}
