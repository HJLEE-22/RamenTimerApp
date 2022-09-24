//
//  BookmarkBasicBackgroundView.swift
//  RamenTimer
//
//  Created by 이형주 on 2022/09/01.
//

import UIKit

class BookmarkBasicBackgroundView: UIView {
    
    lazy var label: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.text = "라면을 골라주세요"
        label.textColor = .systemBlue
        return label
    }()
    
    lazy var ramenImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: ImageNames.ramenImage)
        return imageView
    }()
    
    lazy var stackView: UIStackView = {
       let sv = UIStackView(arrangedSubviews: [label, ramenImageView])
        sv.axis = .vertical
        sv.alignment = .center
        sv.distribution = .fill
        sv.backgroundColor = .clear
        sv.spacing = 20

    return sv
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        self.addSubview(stackView)

        
        label.translatesAutoresizingMaskIntoConstraints = false
        ramenImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([

            ramenImageView.widthAnchor.constraint(equalToConstant: 300),
            ramenImageView.heightAnchor.constraint(equalToConstant: 300),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
        ])
        
        
    }
    
}
