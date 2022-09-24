//
//  BookmarkTimerView.swift
//  RamenTimer
//
//  Created by 이형주 on 2022/08/27.
//

import UIKit

final class BookmarkTimerView: UIView {

    // MARK: - 뷰에 표시할 인스턴스들
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = UIFont.systemFont(ofSize: 120)
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()
    
    lazy var clearTextField: UITextField = {
       let tf = UITextField()
        tf.backgroundColor = .clear
        //커서 깜박이는거 지워야하나?
        tf.tintColor = .clear
        
        return tf
        
    }()
    
    lazy var viewForButtonLeft: UIView = {
        let view = UIView()

        return view
    }()
    
    lazy var viewForButtonRight: UIView = {
        let view = UIView()

        return view
    }()
    
    lazy var stackViewForButton: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [viewForButtonLeft,playButton,viewForButtonRight])
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .equalCentering
        return sv
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: ImageSystemNames.play), for: .normal)
        button.backgroundColor = .clear
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.tintColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        return button
    }()
    
    lazy var timeSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = slider.maximumValue
        slider.isContinuous = true
        slider.maximumTrackTintColor = .lightGray
        slider.minimumTrackTintColor = .darkGray
        slider.backgroundColor = .clear

        return slider
    }()
    
    lazy var cellSugestedTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "권장시간 : "
        
        return label
        
    }()
    
    lazy var suggestedTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        
        return label
    }()
    
    lazy var cellRatingStarLabel: UILabel = {
        let label = UILabel()
        label.text = "권장물양 : "
        label.backgroundColor = .clear
        label.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        label.frame.size.width = 30
        return label
    }()
    
    lazy var waterSuggestedLabel: UILabel = {
        let label = UILabel()
        label.text = "0 ml"
        label.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        label.textAlignment = .right
        return label
    }()
    
    
    
    lazy var firstLabelStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [cellSugestedTimeLabel, suggestedTimeLabel])
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    lazy var secondLabelStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [cellRatingStarLabel, waterSuggestedLabel])
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    lazy var totalLabelStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [firstLabelStackView, secondLabelStackView])
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    lazy var memoTextView: UITextView = {
       let textView = UITextView()
        textView.backgroundColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
        textView.text = ""
        
        
        return textView
    }()
    
    lazy var emptyView: UIView = {
        let emptyView = UIView()
        emptyView.backgroundColor = .clear
        return emptyView
    }()
    
    lazy var mainStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [timeLabel, timeSlider, stackViewForButton, totalLabelStackView, memoTextView, emptyView])
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.backgroundColor = .white
        
        return stackView
    }()
    

    
//    lazy var scrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        scrollView.backgroundColor = .clear
//        scrollView.showsVerticalScrollIndicator = true
//        scrollView.contentSize = CGSize(width: 100, height: 700)
//        scrollView.backgroundColor = .white
//        return scrollView
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func makeUI() {
        self.addSubview(mainStackView)
        self.addSubview(clearTextField)
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        clearTextField.translatesAutoresizingMaskIntoConstraints = false
        playButton.translatesAutoresizingMaskIntoConstraints = false
        viewForButtonLeft.translatesAutoresizingMaskIntoConstraints = false
        viewForButtonRight.translatesAutoresizingMaskIntoConstraints = false
        stackViewForButton.translatesAutoresizingMaskIntoConstraints = false
        timeSlider.translatesAutoresizingMaskIntoConstraints = false
        cellSugestedTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        suggestedTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        cellRatingStarLabel.translatesAutoresizingMaskIntoConstraints = false
        waterSuggestedLabel.translatesAutoresizingMaskIntoConstraints = false
        firstLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        secondLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        totalLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        memoTextView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([

            
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            
            timeLabel.topAnchor.constraint(equalTo: mainStackView.topAnchor, constant: 10),
            timeLabel.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 30),
            timeLabel.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -30),
            timeLabel.heightAnchor.constraint(equalToConstant: 120),

            clearTextField.topAnchor.constraint(equalTo: timeLabel.topAnchor),
            clearTextField.bottomAnchor.constraint(equalTo: timeLabel.bottomAnchor),
            clearTextField.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor),
            clearTextField.trailingAnchor.constraint(equalTo: timeLabel.trailingAnchor),
            

            stackViewForButton.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 30),
            stackViewForButton.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -30),
            stackViewForButton.heightAnchor.constraint(equalToConstant: 80),
            playButton.widthAnchor.constraint(equalToConstant: 70),
            playButton.heightAnchor.constraint(equalToConstant: 70),

            timeSlider.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 30),
            timeSlider.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -30),
            timeSlider.heightAnchor.constraint(equalToConstant: 30),

            totalLabelStackView.topAnchor.constraint(equalTo: stackViewForButton.bottomAnchor, constant: 10),
            totalLabelStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 30),
            totalLabelStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -30),
            totalLabelStackView.heightAnchor.constraint(equalToConstant: 50),

            memoTextView.heightAnchor.constraint(equalToConstant: 150),
            memoTextView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 30),
            memoTextView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -30),
            memoTextView.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: -50),
           
            emptyView.topAnchor.constraint(equalTo: memoTextView.bottomAnchor, constant: 20)

        ])
    }

    
    
    
}

extension BookmarkTimerView: UITextFieldDelegate {
    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //        return false
    //    }
}
