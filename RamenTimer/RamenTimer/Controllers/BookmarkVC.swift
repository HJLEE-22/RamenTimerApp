//
//  BookmarkVC.swift
//  RamenTimer
//
//  Created by 이형주 on 2022/08/27.
//

import UIKit
import AVFoundation
import CoreData

class BookmarkVC: UIViewController {

    // MARK: - coredata property
    
    var originViewFrameY : CGFloat?
    
    var ramens:[RamenData]?
    
    var ramen: RamenData?
    
    var bookmarkedRamens: [RamenData]? {
        didSet {
//            reloadCollectionView()
        }
    }
    
    var selectedIndexPath: IndexPath?

// MARK: - 기본 인스턴스들
    
    private var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        flowLayout.scrollDirection = .horizontal
//        let collectionCellWidth = 120
        flowLayout.itemSize = CGSize(width: 170, height: 170)
        // 아이템 사이 간격 설정
        flowLayout.minimumInteritemSpacing = 10
        // 아이템 위아래 사이 간격 설정
        flowLayout.minimumLineSpacing = 0
        
        // 컬렉션뷰의 속성에 할당
        cv.collectionViewLayout = flowLayout
        return cv
    }()

    let bookmarkTimerView = BookmarkTimerView()
    let bookmarkBasicBackgroundView = BookmarkBasicBackgroundView()
    
    var timer: Timer?
    var player: AVAudioPlayer!
    
    lazy var plusButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
        return button
    }()
    
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
    
    
// MARK: - 뷰 load, appear
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBar()
        setupCollectionView()
        setupCollectionViewConstraints()
        setupPlayButton()
        setupBackgroundView()
        bookmarkTimerView.clearTextField.delegate = self
        reloadCollectionView()


    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        bookmarkedRamens = updateBookmarkedRamenArray().filter( { $0.bookmark == true })
        reloadCollectionView()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        self.removeKeyboardNotifications()
    }

    func reloadCollectionView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
    }
    
    func updateBookmarkedRamenArray() -> [RamenData]{
        CoreDataManager.shared.getRamenListFromCoreData()
    }
    
    
// MARK: - 셋업 함수들
    // MARK: - 네비게이션 셋업
    func setupNaviBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()  // 불투명으로
        //appearance.backgroundColor = .brown     // 색상설정
        
        //appearance.configureWithTransparentBackground()  // 투명으로
        
        navigationController?.navigationBar.tintColor = .blue
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        title = "즐겨찾기"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = plusButton
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    @objc func plusButtonTapped() {
        let bookmarkPlusVC = BookmarkPlusVC()
        show(bookmarkPlusVC, sender: nil)

        
    }
    

    // MARK: - 콜렉션뷰 셋업
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear

        collectionView.register(BookmarkTimerCollectionViewCell.self, forCellWithReuseIdentifier: cellID.forCollectionView)
    }

    func setupCollectionViewConstraints() {
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
//            viewForCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalToConstant: 150)
            
        ])
    }
    
    // MARK: - 타이머뷰 셋업
    func setupBookmarkTimerView() {
//        bookmarkTimerView.layer.cornerRadius = CGFloat(40)
        bookmarkTimerView.layer.borderWidth = 1.5
        bookmarkTimerView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        bookmarkTimerView.clipsToBounds = true
    }
    
    func showBookmarkTimerView() {
        view.addSubview(bookmarkTimerView)
        bookmarkTimerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        
            bookmarkTimerView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 0),
            bookmarkTimerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -10),
            bookmarkTimerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            bookmarkTimerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
    }
    
    // MARK: - 기본 배경 뷰 셋업
    
    func setupBackgroundView() {
        view.backgroundColor = .white
        view.addSubview(bookmarkBasicBackgroundView)
        bookmarkBasicBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookmarkBasicBackgroundView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 0),
            bookmarkBasicBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            bookmarkBasicBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            bookmarkBasicBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    
        
        
    }
    
    
    // MARK: - 카운트다운 레이블 셋업
    func setupTimerLabel(indexPath: IndexPath) {
        
        if let bookmarkedRamens = self.bookmarkedRamens {
            let cellModel = bookmarkedRamens[indexPath.row]
            
            // 개별 ramen 인스턴스에 정보 주기.(레이블 뿐만 아니라 모델 전체 정보 전달)
            self.ramen = cellModel
            guard let settingTimer = cellModel.settingTime,
                  let intSettingTimer = Int(settingTimer) else { return }
            let minutes: Int = intSettingTimer / 60
            let seconds: Int = intSettingTimer - (minutes * 60)
            mins = minutes
            secs = seconds
            
            calculateMinsAndSecs(mins: mins, secs: secs)
            
            //추천 레이블 표시

            if let suggestedTimer = cellModel.suggestedTime,
               let intSuggestedTimer = Int(suggestedTimer) {
                let minutes: Int = intSuggestedTimer / 60
                let seconds: Int = intSuggestedTimer - (minutes * 60)
                
                if minutes == 0 && seconds == 0 {
                    bookmarkTimerView.suggestedTimeLabel.text = "00:00"
                } else if seconds <= 10 && minutes <= 10{
                    bookmarkTimerView.suggestedTimeLabel.text = "0\(minutes):0\(seconds)"
                } else if minutes <= 10 {
                    bookmarkTimerView.suggestedTimeLabel.text = "0\(minutes):\(seconds)"
                } else {
                    bookmarkTimerView.suggestedTimeLabel.text = "\(minutes):\(seconds)"
                }
            }
        }
    }
    
    func calculateMinsAndSecs(mins: Int, secs: Int) {
        if mins == 0 && secs == 0 {
            bookmarkTimerView.timeLabel.text = "00:00"
        } else if secs < 10 && mins < 10 {
            bookmarkTimerView.timeLabel.text = "0\(mins):0\(secs)"
        } else if mins < 10 {
            bookmarkTimerView.timeLabel.text = "0\(mins):\(secs)"
        } else if mins == 10 && secs < 10 {
            bookmarkTimerView.timeLabel.text = "\(mins):0\(secs)"
        } else {
            bookmarkTimerView.timeLabel.text = "\(mins):\(secs)"
        }
    }
    
    // MARK: - 카운트다운 플레이 버튼 셋업
    func setupPlayButton() {
        bookmarkTimerView.playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
    }
    
    func setupPlayButtonForCellSelect() {
        bookmarkTimerView.playButton.isEnabled = true
        bookmarkTimerView.playButton.setImage(UIImage(systemName: ImageSystemNames.play), for: .normal)
        
    }
    
    // 스타트버튼을 누르면 실행하는 함수 + 일시정지
    @objc func playButtonTapped() {
        if bookmarkTimerView.playButton.image(for: .normal) == UIImage(systemName: ImageSystemNames.play) {
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countingTimer), userInfo: nil, repeats: true)
            bookmarkTimerView.playButton.setImage(UIImage(systemName: ImageSystemNames.pause), for: .normal)
            self.bookmarkTimerView.clearTextField.isEnabled = false
        } else {
            timer?.invalidate()
            bookmarkTimerView.playButton.setImage(UIImage(systemName: ImageSystemNames.play), for: .normal)
            self.bookmarkTimerView.clearTextField.isEnabled = true

        }
    }
    
    // MARK: - 카운트다운 숫자표시 셋업
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
            bookmarkTimerView.playButton.isEnabled = false
        }
        self.updateLabel()
        self.updateSlider()
    }

    func updateLabel() {
        if mins == 0 && secs == 0 {
            bookmarkTimerView.timeLabel.text = "00:00"
        } else if secs <= 10 && mins <= 10 {
            bookmarkTimerView.timeLabel.text = "0\(mins):0\(secs)"
        } else if mins <= 10 {
            bookmarkTimerView.timeLabel.text = "0\(mins):\(secs)"
        } else {
            bookmarkTimerView.timeLabel.text = "\(mins):\(secs)"
        }
    }
    
    // MARK: - 슬라이더 셋업
 
    func setupTimeSlider(indexPath: IndexPath) {
        guard let bookmarkedRamens = bookmarkedRamens else { return }
              
        let cellModel = bookmarkedRamens[indexPath.row]

        guard let settingTime = cellModel.settingTime,
              let floatSettingTime = Float(settingTime) else { return }
        bookmarkTimerView.timeSlider.maximumValue = floatSettingTime
        bookmarkTimerView.timeSlider.value = floatSettingTime
    }
    
    func updateSlider() {
        bookmarkTimerView.timeSlider.value = (Float(mins) * Float(60)) + Float(secs)
        print("DEBUG: 타임 슬라이더 변경값 \(bookmarkTimerView.timeSlider.value)")
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
    
    
    
    // MARK: - 권장 물 양 셋업
    func setupSuggestedWater(indexPath: IndexPath) {
        guard let bookmarkedRamens = bookmarkedRamens,
              let water = bookmarkedRamens[indexPath.row].water else {
            return
        }
        
        bookmarkTimerView.waterSuggestedLabel.text = "\(water) ml"

    }
    
    
    // MARK: - 텍스트뷰 저장 버튼 셋업
    
    func setupSaveButton() {
        bookmarkTimerView.memoSavebutton.addTarget(self, action: #selector(saveMemoTapped), for: .touchUpInside)
    }
    
    @objc func saveMemoTapped() {
        self.view.endEditing(true)
        if bookmarkTimerView.memoTextView.text == TextViewPlaceholder.PleaseWrite {
            return
        } else if bookmarkTimerView.memoTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            callUpdateRamenData()
        } else {
            callUpdateRamenData()
        }
    }
    
    func callUpdateRamenData() {
        guard let ramen = self.ramen else { return }
        ramen.memo = bookmarkTimerView.memoTextView.text
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

    
    func setupTimerTextView(indexPath: IndexPath) {
        bookmarkTimerView.memoTextView.delegate = self
        if let bookmarkedRamens = bookmarkedRamens,
           let memoData = bookmarkedRamens[indexPath.row].memo {
            if memoData == "" {
                bookmarkTimerView.memoTextView.text = TextViewPlaceholder.PleaseWrite
                bookmarkTimerView.memoTextView.textColor = .lightGray
            } else {
                bookmarkTimerView.memoTextView.text = memoData
                bookmarkTimerView.memoTextView.textColor = .black
            }
        }
    }
    // MARK: - (텍스트뷰를 위한) 스크롤뷰 셋업
    
    /*
    // 스크롤뷰에서 터치로 키보드 resign하기 위한 함수
    func setupScrollView() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(myTapMethod))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
//        bookmarkTimerView.scrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    @objc func myTapMethod(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
     */
    
    // MARK: - 타이머화면 등장 애니메이션
    func setupBookmarkTimerViewAnimation() {
        
        bookmarkTimerView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -20).isActive = true
        
        UIView.animate(withDuration: 0.3) {
            // 위에서 아래로 내려오는 코드로 짜려면?
            // 파라미터에 curveEaseIn 주고, self.collectionView.center.y -= self.collectionView.bounds.height
            // 이 코드 줘도 안됨.
            self.bookmarkTimerView.layoutIfNeeded()
        }
    }
    
    // MARK: - pickerView 설정
    func showPickerView(indexPath: IndexPath) {
        
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let btnDone = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(onPickDone(_:)))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let btnCancel = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(onPickCancel))
        toolBar.setItems([btnCancel , space , btnDone], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        bookmarkTimerView.clearTextField.inputView = pickerView
        bookmarkTimerView.clearTextField.inputAccessoryView = toolBar

        
    }
    
    @objc func onPickDone(_ sender: UIBarButtonItem) {
        
        let timeToString = String((componentMin * 60) + componentSec)
        guard let ramen = self.ramen else { return print("DEBUG: ramen 없음") }
        ramen.settingTime = timeToString
        
        
        CoreDataManager.shared.updateRamenData(newRamenData: ramen, completion: {
            
            let alert = UIAlertController(title: "시간 변경", message: "타이머 시간이 변경되었습니다.", preferredStyle: .alert)
            let check = UIAlertAction(title: "OK", style: .default) { _ in
                // 피커뷰 종료 -> dismiss 대신 endEditing으로
                self.bookmarkedRamens = self.updateBookmarkedRamenArray().filter( { $0.bookmark == true })
                self.view.endEditing(true)
                guard let selectedIndexPath = self.selectedIndexPath else { return }

                self.setupTimerLabel(indexPath: selectedIndexPath)
                self.setupTimeSlider(indexPath: selectedIndexPath)
                self.setupTimerTextView(indexPath: selectedIndexPath)

            }
            alert.addAction(check)
            self.present(alert, animated: true) { () in
                
            }
        })
         /*
        let alert = UIAlertController(title: "시간 변경", message: "타이머 시간이 변경되었습니다.", preferredStyle: .alert)
        let check = UIAlertAction(title: "OK", style: .default) { _ in
            // 피커뷰 종료 -> dismiss 대신 endEditing으로

            self.view.endEditing(true)
//                self.bookmarkTimerView.setNeedsLayout()
//                self.bookmarkTimerView.layoutIfNeeded()
        }
        alert.addAction(check)
        self.present(alert, animated: true) { () in
            CoreDataManager.shared.updateRamenData(newRamenData: ramen, completion: {
                self.bookmarkedRamens = self.updateBookmarkedRamenArray().filter( { $0.bookmark == true })

            })

        }
          */

        bookmarkTimerView.clearTextField.resignFirstResponder()

    }
         
    @objc func onPickCancel() {

        bookmarkTimerView.clearTextField.resignFirstResponder()

    }

    
}

// MARK: - 콜렉션 뷰 익스텐션
extension BookmarkVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        timer?.invalidate()

        showBookmarkTimerView()
        setupBookmarkTimerView()
        setupTimerLabel(indexPath: indexPath)
        setupTimeSlider(indexPath: indexPath)
        setupPlayButtonForCellSelect()
        setupSuggestedWater(indexPath: indexPath)
        setupTimerTextView(indexPath: indexPath)
        setupBookmarkTimerViewAnimation()
        showPickerView(indexPath: indexPath)
        setupSaveButton()
        self.selectedIndexPath = indexPath

    }
}

extension BookmarkVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookmarkedRamens?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID.forCollectionView, for: indexPath) as! BookmarkTimerCollectionViewCell
        
        
        if let bookmarkedRamens = bookmarkedRamens {
            let cellModel = bookmarkedRamens[indexPath.row]
            if let title = cellModel.title {
                cell.imageView.image = UIImage(named: "\(title)")
            }
            
        }
        return cell
    }
}

// MARK: - 텍스트 뷰 익스텐션
extension BookmarkVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if  textView.text == TextViewPlaceholder.PleaseWrite {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    // 입력이 끝났을때
    func textViewDidEndEditing(_ textView: UITextView) {
        // 비어있으면 다시 플레이스 홀더처럼 입력하기 위해서 조건 확인
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = TextViewPlaceholder.PleaseWrite
            textView.textColor = .lightGray
            textView.resignFirstResponder()
        }
    }
}

// MARK: - pickerView 익스텐션


extension BookmarkVC: UIPickerViewDataSource, UIPickerViewDelegate {
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


    
extension BookmarkVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
    

// paste 막기 위해선 텍스트필드를 커스텀클래스로 사용해야 한다는 데, 지연계산속성으로 구현한 걸 바꾸기가 갑갑하여 우선 딜레이.
//class textField : UITextField {
//override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//     if action == #selector(UIResponderStandardEditActions.paste(_:)) {
//         return false
//     }
//     return super.canPerformAction(action, withSender: sender)
// }
//}
