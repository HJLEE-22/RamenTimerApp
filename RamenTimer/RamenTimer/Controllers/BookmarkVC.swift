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

    // MARK: - 코어데이터 관련 코드 모음(수정예정)
    
    var ramens:[RamenData]?

    var newRamens:[RamenModelCodable]? {
        didSet {
            // Remove all Previous Records
            DatabaseController.deleteAllRamens()
            // Add the new spots to Core Data Context
            self.addNewRamensToCoreData(self.newRamens!)
            // Save them to Core Data
            DatabaseController.saveContext()
            // Reload the tableView
            reloadCollectionView()
        }
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
         self.collectionView.reloadData()
        }
    }

    
//    override func viewWillAppear(_ animated: Bool) {
//        self.ramens = DatabaseController.getAllRamens()
//    }
    
    override func didReceiveMemoryWarning() {
         super.didReceiveMemoryWarning()
         // Dispose of any resources that can be recreated.
     }
    
//    @objc func getDataFromJSON() {
//        print("Updating...")
//
//
//        guard let url = URL( else {return}
//
//        let data = Data(contentsOf: <#T##URL#>)
//        let task = URLSession.shared.dataTask(with: url) {
//            (data, response, error) in
//                guard let dataResponse = data, error == nil else {
//                        print(error?.localizedDescription ?? "Response Error")
//                return }
//
//            do {
//                self.newShows = try JSONDecoder().decode([RamenModelCodable].self, from: dataResponse)
//            } catch {
//                print(error)
//            }
//        }
//
//        task.resume()
//    }
    
    func addNewRamensToCoreData(_ shows: [RamenModelCodable]) {

        for ramen in ramens! {
            let entity = NSEntityDescription.entity(forEntityName: "RamenData", in: DatabaseController.getContext())
            let newRamen = NSManagedObject(entity: entity!, insertInto: DatabaseController.getContext())

            // Create a unique ID for the Show.
            let uuid = UUID()
            // Set the data to the entity
            newRamen.setValue(ramen.title, forKey: "title")
            newRamen.setValue(ramen.number, forKey: "name")
            newRamen.setValue(ramen.bookmark, forKey: "bookmark")
            newRamen.setValue(ramen.brand, forKey: "brand")
            newRamen.setValue(ramen.spicyLevel, forKey: "spicyLevel")
            newRamen.setValue(ramen.water, forKey: "water")
            newRamen.setValue(ramen.settingTime, forKey: "settingTime")
            newRamen.setValue(ramen.suggestedTime, forKey: "suggestedTime")
            newRamen.setValue(ramen.memo, forKey: "memo")
            newRamen.setValue(ramen.color, forKey: "color")
        }

    }
    
    
    
// MARK: - 기본 인스턴스들
    
    



    let ramensDataManager = RamensDataManager()
    
    private var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        flowLayout.scrollDirection = .horizontal
//        let collectionCellWidth = 120
        flowLayout.itemSize = CGSize(width: 170, height: 170)
        // 아이템 사이 간격 설정
        flowLayout.minimumInteritemSpacing = 0
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
//        setupCollectionViewLayout()
        setupCollectionViewConstraints()
//        showCellDetailViews()
        setupPlayButton()
        setupScrollView()
        setupBackgroundView()
        bookmarkTimerView.clearTextField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardNotifications()
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
//      //이전방식
//        navigationController?.pushViewController(bookmarkPlusVC, animated: true)
        
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
        bookmarkTimerView.layer.borderWidth = 10
        bookmarkTimerView.layer.borderColor = UIColor.lightGray.cgColor
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
    // 카운트 하기전에 우선 보여주기
    func setupTimerLabel(indexPath: IndexPath) {
        

        
        if let settingTimer = ramensDataManager.getRamenArray()[indexPath.row].settingTime {
//            bookmarkTimerView.timeLabel.text = settingTimer
            let minutes: Int = settingTimer / 60
            let seconds: Int = settingTimer - (minutes * 60)
            mins = minutes
            secs = seconds
            
            calculateMinsAndSecs(mins: mins, secs: secs)
            
        } else if let suggestTimer = ramensDataManager.getRamenArray()[indexPath.row].suggestedTime {
            let minutes: Int = suggestTimer / 60
            let seconds: Int = suggestTimer - (minutes * 60)
            mins = minutes
            secs = seconds
            calculateMinsAndSecs(mins: mins, secs: secs)
        }
        
        //추천 레이블 표시
        if let suggestTimer = ramensDataManager.getRamenArray()[indexPath.row].suggestedTime {
            let minutes: Int = suggestTimer / 60
            let seconds: Int = suggestTimer - (minutes * 60)

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
    
//    func addActionToLabel() {
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showPickerView))
//        bookmarkTimerView.timeLabel.addGestureRecognizer(tapGestureRecognizer)
//        bookmarkTimerView.timeLabel.isUserInteractionEnabled = true
//    }
    

    
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
        if bookmarkTimerView.playButton.image(for: .normal) == UIImage(systemName: "play.fill") {
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countingTimer), userInfo: nil, repeats: true)
            bookmarkTimerView.playButton.setImage(UIImage(systemName: ImageSystemNames.pause), for: .normal)
        } else {
            timer?.invalidate()
            bookmarkTimerView.playButton.setImage(UIImage(systemName: ImageSystemNames.play), for: .normal)
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
        guard let settingTime = ramensDataManager.getRamenArray()[indexPath.row].settingTime else {
            bookmarkTimerView.timeSlider.maximumValue = Float(ramensDataManager.getRamenArray()[indexPath.row].suggestedTime ?? 0)
            bookmarkTimerView.timeSlider.value = Float(ramensDataManager.getRamenArray()[indexPath.row].suggestedTime ?? 0)
            return
        }
        bookmarkTimerView.timeSlider.maximumValue = Float(settingTime)
        bookmarkTimerView.timeSlider.value = Float(settingTime)
    }
    
    func updateSlider() {
        bookmarkTimerView.timeSlider.value = (Float(mins) * Float(60)) + Float(secs)
        print(bookmarkTimerView.timeSlider.value)
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
    

    
    // MARK: - 별점 셋업
    func setupSuggestedWater(indexPath: IndexPath) {
        guard let water = ramensDataManager.getRamenArray()[indexPath.row].water else { return }
        bookmarkTimerView.waterSuggestedLabel.text = "\(water) ml"
        
        
        
    }
    
    
    // MARK: - 텍스트뷰 셋업

    
    func setupTimerTextView(indexPath: IndexPath) {
        bookmarkTimerView.memoTextView.delegate = self
        if let memoData = ramensDataManager.getRamenArray()[indexPath.row].memo {
            bookmarkTimerView.memoTextView.text = memoData
        } else {
            bookmarkTimerView.memoTextView.text = "메모하실 내용이 있으면 입력하세요."
            bookmarkTimerView.memoTextView.textColor = .lightGray

        }
        
    }
    // MARK: - (텍스트뷰를 위한) 스크롤뷰 셋업
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
    
//    @objc func keyboardWillShow(_ noti: NSNotification){
//        if let keyboardSize = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            if viewYValue == 0 {
//                viewYValue = self.view.frame.origin.y
//            }
//            if self.view.frame.origin.y == viewYValue {
//                viewYValue = self.view.frame.origin.y
//                self.view.frame.origin.y -= keyboardSize.height-UIApplication.shared.windows.first!.safeAreaInsets.bottom
//            }
//
//        }
//
//    }
//
//    @objc func keyboardWillHide(_ noti: NSNotification) {
//        if self.view.frame.origin.y != viewYValue {
//            self.view.frame.origin.y = viewYValue
//        }
//
//    }
    
    
    @objc func keyboardWillShow(_ noti: NSNotification){
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            print(self.view.frame.origin.y)

            self.view.frame.origin.y -= (keyboardHeight-(tabBarController?.tabBar.frame.size.height)!)
        }
    }

    @objc func keyboardWillHide(_ noti: NSNotification) {
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.view.frame.origin.y += (keyboardHeight-(tabBarController?.tabBar.frame.size.height)!)
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
        
        bookmarkTimerView.clearTextField.inputView = pickerView
        bookmarkTimerView.clearTextField.inputAccessoryView = toolBar

    }
    
    @objc func onPickDone() {
        /// 확인 눌렀을 때 액션 정의
        
        settedTime = (componentMin * 60) + componentSec
        // 여기서 라면indexPath.row 값을 어떻게 전달받지? 아놔...
        // 내가 그래서... 혹시 몰라서 라면들에 인덱스값을 걸어놓긴 했거든?
        // 그거를... 활용해야하나...?
        // 근데 만약 데이터에 해당 인덱스값이 없는 경우라면 어떡하지?ㅜ
        // 일단 어쨌든 코어데이터에 값을 변경해야 하는 경우이니 나중에 다시 해보기로.
        bookmarkTimerView.clearTextField.resignFirstResponder()

    }
         
    // 피커뷰 > 취소 클릭
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
        showPickerView()
    }
    
}

extension BookmarkVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ramensDataManager.getRamenArray().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID.forCollectionView, for: indexPath) as! BookmarkTimerCollectionViewCell
        cell.imageView.image = ramensDataManager.getRamenArray()[indexPath.row].image
        return cell
    }
}

// MARK: - 텍스트 뷰 익스텐션
extension BookmarkVC: UITextViewDelegate {
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
