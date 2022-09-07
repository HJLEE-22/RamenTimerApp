//
//  RamenSearchCollectionViewCell.swift
//  RamenTimer
//
//  Created by 이형주 on 2022/09/06.
//

import UIKit

class RamenSearchCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    
    
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                imageView.backgroundColor = .lightGray
            } else {
                imageView.backgroundColor = .clear
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        setupImageView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupImageView() {
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
    }
}




