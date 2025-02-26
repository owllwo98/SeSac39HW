//
//  ShoppingDetailCollectionViewCell.swift
//  SeSacHW16
//
//  Created by 변정훈 on 1/15/25.
//

import UIKit
import Alamofire
import SnapKit
import Kingfisher

class ShoppingDetailCollectionViewCell: UICollectionViewCell {
    
    static let id = "ShoppingDetailCollectionViewCell"
    
    let itemImageView: UIImageView = UIImageView()
    let mallName: UILabel = UILabel()
    let title: UILabel = UILabel()
    let lprice: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureUI()
        configureLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        [itemImageView, mallName, title, lprice].forEach {
            contentView.addSubview($0)
        }
    }
    
    func configureUI() {
        
        mallName.textColor = .lightGray
        mallName.font = .systemFont(ofSize: 8, weight: .regular)
        
        title.textColor = .systemGray6
        title.font = .systemFont(ofSize: 8, weight: .regular)
        title.numberOfLines = 2
        
        lprice.textColor = .white
        lprice.font = .systemFont(ofSize: 12, weight: .regular)
        
    }
    
    func configureLayout() {
        itemImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            
        }
        
        mallName.snp.makeConstraints { make in
            make.top.equalTo(itemImageView.snp.bottom).inset(-4)
            make.leading.equalToSuperview().inset(4)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(mallName.snp.bottom).inset(-4)
            make.leading.equalToSuperview().inset(4)
            make.trailing.equalToSuperview().inset(4)
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
    }
    
    
   
}
