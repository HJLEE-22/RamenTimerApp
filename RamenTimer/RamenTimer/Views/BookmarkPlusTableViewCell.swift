//
//  BookmarkPlusTableViewCell.swift
//  RamenTimer
//
//  Created by 이형주 on 2022/08/30.
//

import UIKit
import CoreMedia

protocol CellButtonActionDelegate: AnyObject {
    func bookmarkButtonTapped()
}



class BookmarkPlusTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    var bookmarButtonAction: (() -> ())?
    var cellDelegate: CellButtonActionDelegate?
    
    
    lazy var bookmarkButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: ImageSystemNames.star), for: .normal)
//        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        return button
        
    }()

    lazy var lineImage: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(systemName: ImageSystemNames.lineThreeHorizontal)
        imageview.scalesLargeContentImage = false
        imageview.contentMode = .scaleAspectFit
        return imageview
    }()
    
    let ramenImage = UIImageView()
    
    lazy var cellRamenTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "이름 : "
       return label
    }()
    
    lazy var ramenTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "라면이름"
        return label
    }()

    lazy var cellTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "시간 : "

        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "05:00"
        return label
    }()


    lazy var mainStackView: UIStackView = {
       let sv = UIStackView(arrangedSubviews: [bookmarkButton, ramenImage, SubStackView, lineImage])
        sv.spacing = 10
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fill
        return sv
    }()
    
    lazy var SubStackView: UIStackView = {
        let sv = UIStackView()
        sv.addArrangedSubview(nameSubStackView)
        sv.addArrangedSubview(ratingSubStackView)
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.spacing = 20
        return sv
    }()
    lazy var nameSubStackView: UIStackView = {
        let sv = UIStackView()
        sv.addArrangedSubview(cellRamenTitleLabel)
        sv.addArrangedSubview(ramenTitleLabel)
        sv.axis = .horizontal
        sv.alignment = .leading
        sv.distribution = .fill
        return sv
    }()
    
    lazy var ratingSubStackView: UIStackView = {
        let sv = UIStackView()
        sv.addArrangedSubview(cellTimeLabel)
        sv.addArrangedSubview(timeLabel)
        sv.axis = .horizontal
        sv.alignment = .leading
        sv.distribution = .fill
        return sv
    }()
    
    // MARK: - LifeCycle
    
    // 커스텀 셀 작성시 삽입
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
//        self.bookmarkButton.isUserInteractionEnabled = true
        self.bookmarkButton.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    @objc func bookmarkButtonTapped() {
//        bookmarButtonAction?()
//
//    }
    
    // MARK: - Actions
    
    @objc func bookmarkButtonTapped() {
        cellDelegate?.bookmarkButtonTapped()
        if bookmarkButton.image(for: .normal) == UIImage(systemName: ImageSystemNames.star) {
            bookmarkButton.setImage(UIImage(systemName: ImageSystemNames.starFill), for: .normal)
        } else {
            bookmarkButton.setImage(UIImage(systemName: ImageSystemNames.star), for: .normal)
        }
    }
    
    // MARK: - Helpers
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

 
    }
    
    func configureUI() {
        // 테이블뷰에 코드로 ui 작성할 때 contentView 위에다가 놓기.
        contentView.addSubview(mainStackView)
        
        lineImage.translatesAutoresizingMaskIntoConstraints = false
        bookmarkButton.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        SubStackView.translatesAutoresizingMaskIntoConstraints = false
        nameSubStackView.translatesAutoresizingMaskIntoConstraints = false
        ratingSubStackView.translatesAutoresizingMaskIntoConstraints = false
        cellRamenTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        ramenTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        cellTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false

        
        SubStackView.setContentHuggingPriority(.init(rawValue: 249), for: .horizontal)
 
        cellRamenTitleLabel.setContentHuggingPriority(.init(rawValue: 252), for: .horizontal)
        
        cellTimeLabel.setContentHuggingPriority(.init(rawValue: 252), for: .horizontal)
        
        bookmarkButton.setContentHuggingPriority(.init(rawValue: 251), for: .horizontal)
        
        
        
        NSLayoutConstraint.activate([
//            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15 ),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            ramenImage.widthAnchor.constraint(equalToConstant: 100),
            ramenImage.heightAnchor.constraint(equalToConstant: 100),
            
            lineImage.widthAnchor.constraint(equalToConstant: 30),


            
            
        ])
    }

}


