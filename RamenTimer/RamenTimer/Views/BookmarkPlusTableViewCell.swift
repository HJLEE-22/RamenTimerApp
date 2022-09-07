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

    var bookmarButtonAction: (() -> ())?
    var cellDelegate: CellButtonActionDelegate?
    
    
    lazy var bookmarkButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
//        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        return button
        
    }()

    lazy var lineImage: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(systemName: "line.3.horizontal")
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

    lazy var cellRatingLabel: UILabel = {
        let label = UILabel()
        label.text = "별점 : "

        return label
    }()
    
    lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.text = "⭐️⭐️⭐️"
        return label
    }()

    lazy var cellSettingTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "설정시간 : "
        return label
    }()
    lazy var settingTimeLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var cellSuggestingTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "권장시간 : "
        return label
    }()
    
    lazy var suggestingTimeLabel: UILabel = {
        let label = UILabel()
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
        sv.addArrangedSubview(cellRatingLabel)
        sv.addArrangedSubview(ratingLabel)
        sv.axis = .horizontal
        sv.alignment = .leading
        sv.distribution = .fill
        return sv
    }()
    
    
    // 커스텀 셀 작성시 삽입
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
//        self.bookmarkButton.isUserInteractionEnabled = true
//        self.bookmarkButton.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        self.bookmarkButton.addTarget(self, action: #selector(bookmarkButtonTapped2), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    @objc func bookmarkButtonTapped() {
//        bookmarButtonAction?()
//
//    }
    
    @objc func bookmarkButtonTapped2() {
        cellDelegate?.bookmarkButtonTapped()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureUI() {
        self.addSubview(mainStackView)
        
        lineImage.translatesAutoresizingMaskIntoConstraints = false
        bookmarkButton.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        SubStackView.translatesAutoresizingMaskIntoConstraints = false
        nameSubStackView.translatesAutoresizingMaskIntoConstraints = false
        ratingSubStackView.translatesAutoresizingMaskIntoConstraints = false
        cellRamenTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        ramenTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        cellRatingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        cellSettingTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        settingTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        cellSuggestingTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        suggestingTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        SubStackView.setContentHuggingPriority(.init(rawValue: 249), for: .horizontal)
 
        cellRamenTitleLabel.setContentHuggingPriority(.init(rawValue: 252), for: .horizontal)
        
        cellRatingLabel.setContentHuggingPriority(.init(rawValue: 252), for: .horizontal)
        
        bookmarkButton.setContentHuggingPriority(.init(rawValue: 251), for: .horizontal)
        
        
        
        NSLayoutConstraint.activate([
//            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15 ),
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
//            SubStackView.centerYAnchor.constraint(equalTo: mainStackView.centerYAnchor) ,

            
            ramenImage.widthAnchor.constraint(equalToConstant: 100),
            ramenImage.heightAnchor.constraint(equalToConstant: 100),
//
            
            lineImage.widthAnchor.constraint(equalToConstant: 30),

//
            
            
        ])
    }

}


