import UIKit
import SnapKit

class ShoppingDetailView: BaseView {
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .green
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    let standardButton = ShoppingDetailView.createButton(title: "  정확도  ", tag: 0)
    let dateSortButton = ShoppingDetailView.createButton(title: "  날짜순  ", tag: 1)
    let highPriceSortButton = ShoppingDetailView.createButton(title: "  가격높은순  ", tag: 2)
    let lowPriceSortButton = ShoppingDetailView.createButton(title: "  가격낮은순  ", tag: 3)
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2 - 16, height: UIScreen.main.bounds.width / 2 - 16)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.minimumLineSpacing = 60
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    override func configureHierarchy() {
        [totalLabel, standardButton, dateSortButton, highPriceSortButton, lowPriceSortButton, collectionView].forEach {
            addSubview($0)
        }
    }
    
    override func configureLayout() {
        totalLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalToSuperview().inset(8)
        }
        
        standardButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).inset(-4)
            make.leading.equalToSuperview().inset(8)
        }
        
        dateSortButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).inset(-4)
            make.leading.equalTo(standardButton.snp.trailing).inset(-10)
        }
        
        highPriceSortButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).inset(-4)
            make.leading.equalTo(dateSortButton.snp.trailing).inset(-10)
        }
        
        lowPriceSortButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).inset(-4)
            make.leading.equalTo(highPriceSortButton.snp.trailing).inset(-10)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(highPriceSortButton.snp.bottom).inset(-8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        backgroundColor = .black
        standardButton.backgroundColor = .white
        standardButton.setTitleColor(.black, for: .normal)
    }
    
    private static func createButton(title: String, tag: Int) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.tag = tag
        return button
    }
}
