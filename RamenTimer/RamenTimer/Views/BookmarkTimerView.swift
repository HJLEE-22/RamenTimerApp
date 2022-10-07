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
        label.font = UIFont.boldSystemFont(ofSize: 100)
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()
    
    lazy var clearTextField: UITextField = {
       let tf = CustomTextfield()
        tf.backgroundColor = .clear
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
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: ImageSystemNames.play), for: .normal)
        button.backgroundColor = .clear
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.tintColor = Colors.customPink
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
        slider.thumbTintColor = .clear
        slider.isEnabled = false
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
    
    lazy var cellWaterSuggestedLabel: UILabel = {
        let label = UILabel()
        label.text = "권장물양 : "
        label.backgroundColor = .clear
        return label
    }()
    
    lazy var waterSuggestedLabel: UILabel = {
        let label = UILabel()
        label.text = "0 ml"

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
       let stackView = UIStackView(arrangedSubviews: [cellWaterSuggestedLabel, waterSuggestedLabel])
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
        textView.backgroundColor = Colors.customYellow
        textView.text = ""
//        textView.setContentHuggingPriority(.defaultLow, for: .vertical)
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        return textView
    }()
    
//    lazy var emptyView: UIView = {
//        let emptyView = UIView()
//        emptyView.backgroundColor = .clear
//        return emptyView
//    }()
    
    lazy var mainStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [timeLabel, timeSlider, playButton, totalLabelStackView, memoTextView, memoSavebutton])
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.backgroundColor = .white
        
        return stackView
    }()
    
    lazy var memoSavebutton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("메모 저장", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
//        button.layer.borderColor =
//        button.layer.borderWidth = 3
        button.layer.cornerRadius = 10
        button.backgroundColor = Colors.customlightGrey

        return button
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
       // stackViewForButton.translatesAutoresizingMaskIntoConstraints = false
        timeSlider.translatesAutoresizingMaskIntoConstraints = false
        cellSugestedTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        suggestedTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        cellWaterSuggestedLabel.translatesAutoresizingMaskIntoConstraints = false
        waterSuggestedLabel.translatesAutoresizingMaskIntoConstraints = false
        firstLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        secondLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        totalLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        memoTextView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
//        emptyView.translatesAutoresizingMaskIntoConstraints = false
        memoSavebutton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([

            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
//            timeLabel.topAnchor.constraint(equalTo: mainStackView.topAnchor, constant: 10),
            
            timeLabel.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 30),
            timeLabel.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -30),
            timeLabel.heightAnchor.constraint(equalToConstant: 100),
            timeLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            
            clearTextField.topAnchor.constraint(equalTo: timeLabel.topAnchor),
            clearTextField.bottomAnchor.constraint(equalTo: timeLabel.bottomAnchor),
            clearTextField.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor),
            clearTextField.trailingAnchor.constraint(equalTo: timeLabel.trailingAnchor),
        
            
             
             timeSlider.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 30),
             timeSlider.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -30),
//             timeSlider.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: -25),
             timeSlider.heightAnchor.constraint(equalToConstant: 30),
            
           
            
//            stackViewForButton.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 30),
//            stackViewForButton.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -30),
//            stackViewForButton.heightAnchor.constraint(equalToConstant: 80),
            playButton.topAnchor.constraint(equalTo: timeSlider.bottomAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 80),
            playButton.heightAnchor.constraint(equalToConstant: 80),

            


            totalLabelStackView.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 0),
            totalLabelStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 30),
            totalLabelStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -30),
            totalLabelStackView.heightAnchor.constraint(equalToConstant: 50),

             
            
            memoTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 150),
            memoTextView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 30),
            memoTextView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -30),
//            memoTextView.topAnchor.constraint(equalTo: totalLabelStackView.bottomAnchor, constant: 0),
//            memoTextView.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: -50),
//            memoTextView.topAnchor.constraint(equalTo: totalLabelStackView.bottomAnchor, constant: -50),
           
            
            memoSavebutton.heightAnchor.constraint(equalToConstant: 30),
            memoSavebutton.widthAnchor.constraint(equalToConstant: 100),
            memoSavebutton.centerXAnchor.constraint(equalTo: centerXAnchor),
//            memoSavebutton.topAnchor.constraint(equalTo: memoTextView.bottomAnchor, constant: 10),
            
//            emptyView.topAnchor.constraint(equalTo: memoSavebutton.bottomAnchor, constant: 20),
//            emptyView.heightAnchor.constraint(equalToConstant: 20),
//            emptyView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)

            
        ])
    }

    
    
    
}

extension BookmarkTimerView: UITextFieldDelegate {

}
