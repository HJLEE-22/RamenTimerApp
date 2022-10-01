//
//  RamenSearchDetailVC.swift
//  RamenTimer
//
//  Created by 이형주 on 2022/09/07.
//

import UIKit
import AVFoundation

class RamenSearchDetailVC: UIViewController {

    let ramenSearchDetailVeiw = RamenSearchDetailView()

    var ramenData: RamenData?
    
    var timer: Timer?
    var player: AVAudioPlayer!
    
    // MARK: - 피커뷰 사용에 필요한 인스턴스들
    var availableMinutes = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    var availableSeconds: [Int] = {
        var seconds = [Int]()
        for i in 0...60 {
            seconds.append(i)
        }
        return seconds
    }()

    var mins: Int = 0
    var secs: Int = 0
    
    var componentMin: Int = 0
    var componentSec: Int = 0
    
    var settedTime: Int?
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        self.view = ramenSearchDetailVeiw
        setupTitleLabel()
        updateViewConstraints()
        setupTimerLabel()
        setupTimeSlider()
        setupPlayButtonForCellSelect()
        setupSuggestedWater()
        setupTimerTextView()
        showPickerView()
        setupSaveButton()
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        self.resignFirstResponder()
    }

    override func updateViewConstraints() {
        self.view.frame.size.height = UIScreen.main.bounds.height - 150
        self.view.frame.origin.y = 150
        self.view.layer.cornerRadius = 15
        super.updateViewConstraints()

    }

    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardNotifications()
    }
    
    // MARK: - 타이틀 레이블 셋업
    func setupTitleLabel() {
        guard let ramenData = ramenData else { return }

        if let title = ramenData.title {
            ramenSearchDetailVeiw.titleLabel.text = title
        }
        
    }

    // MARK: - 카운트다운 레이블 셋업
    // 카운트 하기전에 우선 보여주기
    func setupTimerLabel() {
        
        guard let ramenData = ramenData else { return }

        if let settingTimer = ramenData.settingTime,
           let intSettingTimer = Int(settingTimer) {
            
            let minutes: Int = intSettingTimer / 60
            let seconds: Int = intSettingTimer - (minutes * 60)
            mins = minutes
            secs = seconds
            
            calculateMinsAndSecs(mins: mins, secs: secs)
            
        }
        
        //추천 레이블 표시
        if let suggestTimer = ramenData.suggestedTime,
            let intSuggestedTimer = Int(suggestTimer) {
            let minutes: Int = intSuggestedTimer / 60
            let seconds: Int = intSuggestedTimer - (minutes * 60)

            if minutes == 0 && seconds == 0 {
                ramenSearchDetailVeiw.suggestedTimeLabel.text = "00:00"
            } else if seconds <= 10 && minutes <= 10{
                ramenSearchDetailVeiw.suggestedTimeLabel.text = "0\(minutes):0\(seconds)"
            } else if minutes <= 10 {
                ramenSearchDetailVeiw.suggestedTimeLabel.text = "0\(minutes):\(seconds)"
            } else {
                ramenSearchDetailVeiw.suggestedTimeLabel.text = "\(minutes):\(seconds)"
            }
        }
    }
    
    func calculateMinsAndSecs(mins: Int, secs: Int) {
        if mins == 0 && secs == 0 {
            ramenSearchDetailVeiw.timeLabel.text = "00:00"
        } else if secs < 10 && mins < 10 {
            ramenSearchDetailVeiw.timeLabel.text = "0\(mins):0\(secs)"
        } else if mins < 10 {
            ramenSearchDetailVeiw.timeLabel.text = "0\(mins):\(secs)"
        } else if mins == 10 && secs < 10 {
            ramenSearchDetailVeiw.timeLabel.text = "\(mins):0\(secs)"
        } else {
            ramenSearchDetailVeiw.timeLabel.text = "\(mins):\(secs)"
        }
    }
    
    // MARK: - 카운트다운 플레이 버튼 셋업
    func setupPlayButton() {
        ramenSearchDetailVeiw.playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
    }
    
    func setupPlayButtonForCellSelect() {
        ramenSearchDetailVeiw.playButton.isEnabled = true
        ramenSearchDetailVeiw.playButton.setImage(UIImage(systemName: ImageSystemNames.play), for: .normal)
        
    }
    
    // 스타트버튼을 누르면 실행하는 함수 + 일시정지
    @objc func playButtonTapped() {
        if ramenSearchDetailVeiw.playButton.image(for: .normal) == UIImage(systemName: ImageSystemNames.play) {
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countingTimer), userInfo: nil, repeats: true)
            ramenSearchDetailVeiw.playButton.setImage(UIImage(systemName: ImageSystemNames.pause), for: .normal)
        } else {
            timer?.invalidate()
            ramenSearchDetailVeiw.playButton.setImage(UIImage(systemName: ImageSystemNames.play), for: .normal)
        }
    }
    
    // 카운트 실행 (Timer.scheduledTimer)
    @objc func countingTimer() {
        if self.secs > 0 {
            self.secs -= 1
        } else if self.mins > 0 && self.secs == 0 {
            self.mins -= 1
            self.secs = 59
        } else {
            self.mins = 0
            self.secs = 0
            timer?.invalidate()
            AudioServicesPlaySystemSound(SystemSoundID(1000))
            configureTimerAlert()
            ramenSearchDetailVeiw.playButton.isEnabled = false
        }
        self.updateLabel()
        self.updateSlider()
    }

    func updateLabel() {
        if mins == 0 && secs == 0 {
            ramenSearchDetailVeiw.timeLabel.text = "00:00"
        } else if secs <= 10 && mins <= 10 {
            ramenSearchDetailVeiw.timeLabel.text = "0\(mins):0\(secs)"
        } else if mins <= 10 {
            ramenSearchDetailVeiw.timeLabel.text = "0\(mins):\(secs)"
        } else {
            ramenSearchDetailVeiw.timeLabel.text = "\(mins):\(secs)"
        }
    }
    
    // MARK: - 슬라이더 셋업
 
    func setupTimeSlider() {
        
        guard let ramenData = ramenData,
              let settingTime = ramenData.settingTime,
              let floatSettingTime = Float(settingTime) else { return }
        ramenSearchDetailVeiw.timeSlider.maximumValue = floatSettingTime
        ramenSearchDetailVeiw.timeSlider.value = floatSettingTime
    }
    
    func updateSlider() {
        ramenSearchDetailVeiw.timeSlider.value = (Float(mins) * Float(60)) + Float(secs)
        print(ramenSearchDetailVeiw.timeSlider.value)
    }
    
    func configureTimerAlert() {
        let url = Bundle.main.url(forResource: AlarmSound.name, withExtension: AlarmSound.extention)
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
        player.volume = 0.5
        
        let alert = UIAlertController(title: "타이머 종료", message: "라면을 건져주세요.", preferredStyle: .alert)
        let check = UIAlertAction(title: "OK", style: .default) { _ in
            self.player.stop()
        }
        alert.addAction(check)
        self.present(alert, animated: true)
    }
    
    // MARK: - 권장물양 셋업
    func setupSuggestedWater() {
        guard let ramenData = ramenData, let water = ramenData.water else { return }
        ramenSearchDetailVeiw.suggestedWaterLabel.text = "\(water) ml"
    }
    
    // MARK: - 텍스트뷰 저장 버튼 셋업
    
    func setupSaveButton() {
        ramenSearchDetailVeiw.memoSavebutton.addTarget(self, action: #selector(saveMemoTapped), for: .touchUpInside)
    }
    
    @objc func saveMemoTapped() {
        if ramenSearchDetailVeiw.memoTextView.text == TextViewPlaceholder.PleaseWrite {
            return
        } else if ramenSearchDetailVeiw.memoTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            callUpdateRamenData()
        } else {
            callUpdateRamenData()
            
        }
        
    }
    
    func callUpdateRamenData() {
        guard let ramen = self.ramenData else { return }
        ramen.memo = ramenSearchDetailVeiw.memoTextView.text
        CoreDataManager.shared.updateRamenData(newRamenData: ramen, completion: {
            print("DEBUG: ramen 메모 변경: \(ramen)")
            let alert = UIAlertController(title: "메모 변경", message: "메모가 변경되었습니다.", preferredStyle: .alert)
            let check = UIAlertAction(title: "OK", style: .default) { _ in
                
            }
            alert.addAction(check)
            self.present(alert, animated: true)
        })
    }
    
    
    
    // MARK: - 텍스트뷰 셋업

    
    func setupTimerTextView() {
        ramenSearchDetailVeiw.memoTextView.delegate = self
        guard let ramenData = ramenData else { return }

        if let memoData = ramenData.memo {
            ramenSearchDetailVeiw.memoTextView.text = memoData
        } else {
            ramenSearchDetailVeiw.memoTextView.text = "메모하실 내용이 있으면 입력하세요."
            ramenSearchDetailVeiw.memoTextView.textColor = .lightGray

        }
        
    }
    // MARK: - (텍스트뷰를 위한) 스크롤뷰 셋업
    // 스크롤뷰에서 터치로 키보드 resign하기 위한 함수
//    func setupScrollView() {
//        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(myTapMethod))
//        singleTapGestureRecognizer.numberOfTapsRequired = 1
//        singleTapGestureRecognizer.isEnabled = true
//        singleTapGestureRecognizer.cancelsTouchesInView = false
//        ramenSearchDetailVeiw.scrollView.addGestureRecognizer(singleTapGestureRecognizer)
//    }
    
    @objc func myTapMethod(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // MARK: - 키보드 화면 애니메이션
    
//    var viewYValue = CGFloat(0)
    
    func addKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ noti: NSNotification){
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            print(self.view.frame.origin.y)
            print(self.ramenSearchDetailVeiw.frame.origin.y)
            print(keyboardHeight)
            self.view.frame.origin.y -= keyboardHeight - 150
        }
    }

    @objc func keyboardWillHide(_ noti: NSNotification) {
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.view.frame.origin.y += keyboardHeight - 150
        }

    }
    
    // MARK: - pickerView 설정
     func showPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let btnDone = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(onPickDone))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let btnCancel = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(onPickCancel))
        toolBar.setItems([btnCancel , space , btnDone], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        ramenSearchDetailVeiw.clearTextField.inputView = pickerView
        ramenSearchDetailVeiw.clearTextField.inputAccessoryView = toolBar

    }
    
    @objc func onPickDone() {
        /// 확인 눌렀을 때 액션 정의
        
        let timeToString = String((componentMin * 60) + componentSec)
        guard let ramen = self.ramenData else { return }
        ramen.settingTime = timeToString
        CoreDataManager.shared.updateRamenData(newRamenData: ramen, completion: {
            print("피커뷰로 시간 바뀐 \(ramen)")
            
            let alert = UIAlertController(title: "시간 변경", message: "타이머 시간이 변경되었습니다.", preferredStyle: .alert)
            let check = UIAlertAction(title: "OK", style: .default) { _ in
                // 피커뷰 종료 -> dismiss 대신 endEditing으로
                self.view.endEditing(true)
            }
            alert.addAction(check)
            self.present(alert, animated: true)
            
        })

        ramenSearchDetailVeiw.clearTextField.resignFirstResponder()

    }
         
    // 피커뷰 > 취소 클릭
    @objc func onPickCancel() {

        ramenSearchDetailVeiw.clearTextField.resignFirstResponder()

    }
    
}

// MARK: - 텍스트 뷰 익스텐션
extension RamenSearchDetailVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if  textView.text == "메모하실 내용이 있으면 입력하세요." {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    // 입력이 끝났을때
    func textViewDidEndEditing(_ textView: UITextView) {
        // 비어있으면 다시 플레이스 홀더처럼 입력하기 위해서 조건 확인
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "메모하실 내용이 있으면 입력하세요."
            textView.textColor = .lightGray
            textView.resignFirstResponder()
        }
    }
    
//    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
//        self.view.endEditing(true)
//        return false
//    }
}

// MARK: - pickerView 익스텐션


extension RamenSearchDetailVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return availableMinutes.count
        case 1:
            return availableSeconds.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return String(availableMinutes[row])
        case 1:
            return String(availableSeconds[row])
        default:
            return ""
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
        case 0:
            componentMin = availableMinutes[row]
        case 1:
            componentSec = availableSeconds[row]
        default:
            break
        }
        calculateMinsAndSecs(mins: componentMin, secs: componentSec)
    }
    
}


    
extension RamenSearchDetailVC: UITextFieldDelegate {
    
}



// half modal view code
//import UIKit
//
//class RamenSearchDetailVC: UIPresentationController {
//
//    let blurEffectView: UIVisualEffectView!
//    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
//    var check: Bool = false
//
//    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
//        let blurEffect = UIBlurEffect(style: .dark)
//        blurEffectView = UIVisualEffectView(effect: blurEffect)
//        super.init(presentedViewController: presentedViewController, presenting: presentedViewController)
//        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        self.blurEffectView.isUserInteractionEnabled = true
//        self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
//    }
//
//    override var frameOfPresentedViewInContainerView: CGRect {
//        CGRect(origin: CGPoint(x: 0,
//                               y: self.containerView!.frame.height * 181 / 800),
//               size: CGSize(width: self.containerView!.frame.width,
//                            height: self.containerView!.frame.height * 619 / 800))
//    }
//
//    // 모달이 올라갈 때 뒤에 있는 배경을 검은색 처리해주는 용도
//    override func presentationTransitionWillBegin() {
//        self.blurEffectView.alpha = 0
//        self.containerView!.addSubview(blurEffectView)
//        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in self.blurEffectView.alpha = 0.7},
//                                                                    completion: nil)
//    }
//
//    // 모달이 없어질 때 검은색 배경을 슈퍼뷰에서 제거
//    override func dismissalTransitionWillBegin() {
//        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in self.blurEffectView.alpha = 0},
//                                                                    completion: { _ in self.blurEffectView.removeFromSuperview()})
//    }
//
//    // 모달의 크기가 조절됐을 때 호출되는 함수
//    override func containerViewDidLayoutSubviews() {
//        super.containerViewDidLayoutSubviews()
//        blurEffectView.frame = containerView!.bounds
//        self.presentedView?.layer.cornerRadius = 15
//    }
//
//    @objc func dismissController() {
//        self.presentedViewController.dismiss(animated: true, completion: nil)
//    }
//}
