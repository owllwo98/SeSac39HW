//
//  BaseView.swift
//  SeSac39HW
//
//  Created by 변정훈 on 2/25/25.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        configureHierarchy()
        configureLayout()
        configureView()
        
        
    }
    
    func configureHierarchy() {}
    func configureLayout() {}
    func configureView() {}
    
    
    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
