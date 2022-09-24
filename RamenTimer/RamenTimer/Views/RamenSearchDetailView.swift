//
//  RamenSearchDetailView.swift
//  RamenTimer
//
//  Created by 이형주 on 2022/09/06.
//

import UIKit
import CoreData

class RamenSearchDetailView: UIView {
    
    
    
    

    
    // MARK: - 뷰에 표시할 인스턴스들
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "라면"
        label.font = UIFont.systemFont(ofSize: 30)
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    
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

        return button
    }()
    
    lazy var timeSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = slider.maximumValue
        slider.isContinuous = true
        slider.maximumTrackTintColor = .lightGray
        slider.minimumTrackTintColor = .systemBlue
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
    
    lazy var cellSuggestedWaterLabel: UILabel = {
        let label = UILabel()
        label.text = "권장물양 : "
        label.backgroundColor = .clear
        label.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
//        label.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)

        label.frame.size.width = 30
        return label
    }()
    
    lazy var suggestedWaterLabel: UILabel = {
        let label = UILabel()
        label.text = "500 ml"
        label.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        label.textAlignment = .right
//        label.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)

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
       let stackView = UIStackView(arrangedSubviews: [cellSuggestedWaterLabel, suggestedWaterLabel])
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
        textView.frame.size.height = 50
        textView.backgroundColor = .systemBlue
        textView.text = ""

        return textView
    }()
    
    lazy var emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear

        return view
    }()
    
    lazy var mainStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [titleLabel, timeLabel, timeSlider, stackViewForButton, totalLabelStackView, memoTextView, emptyView])
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .vertical
        
        stackView.backgroundColor = .white
        
        return stackView
    }()
    


    
    
    // MARK: - init 생성
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
        
//        clearTextField.delegate = self

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ui 생성
    
    func makeUI() {
        self.addSubview(mainStackView)
        self.addSubview(clearTextField)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        clearTextField.translatesAutoresizingMaskIntoConstraints = false
        playButton.translatesAutoresizingMaskIntoConstraints = false
        viewForButtonLeft.translatesAutoresizingMaskIntoConstraints = false
        viewForButtonRight.translatesAutoresizingMaskIntoConstraints = false
        stackViewForButton.translatesAutoresizingMaskIntoConstraints = false
        timeSlider.translatesAutoresizingMaskIntoConstraints = false
        cellSugestedTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        suggestedTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        cellSuggestedWaterLabel.translatesAutoresizingMaskIntoConstraints = false
        suggestedWaterLabel.translatesAutoresizingMaskIntoConstraints = false
        firstLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        secondLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        totalLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        memoTextView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),

            titleLabel.topAnchor.constraint(equalTo: mainStackView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -30),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
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
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    
    
    
    
}

extension RamenSearchDetailView: UITextFieldDelegate {
    
}
    
    
    
    
    




