# RamenTimer

CoreData를 이용한 라면 타이머 앱

[https://apps.apple.com/kr/app/ramentimer/id6443728621](https://apps.apple.com/kr/app/ramentimer/id6443728621)

### 프로젝트 소개

- 인스턴스 라면의 타이머 앱입니다.
- 각 라면마다 권장 제조시간 및 물의 양 등의 정보가 기록되어 있어 사용이 편리합니다.
- 자주찾는 라면을 북마크하고, 나만의 제조시간 및 메모를 작성하여 저장할 수 있습니다.

### 기술 스택

- 언어: Swift5
- 구조: MVC
- UI: UIKit(코드로 작성)
- 그 외 프레임워크: CoreData, AVFoundation
- 그 외 라이브러리: IQKeyboardManagerSwift

### 구현 기능

- 각 라면마다 권장 제조시간 및 물의 양과 같은 정보가 CoreData에 저장됩니다.
- CollectionView와 TableView를 사용하여 라면을 검색하고,  즐겨찾기하며 순서 이동 등 관리가 가능합니다.
- 나만의 제조 방법을 기록하고 저장할 수 있습니다.

### 주요 문제해결 과정

<details>
<summary>시계처럼 작동하는 Timer Label 생성 및 사용자 수정 가능 모드 구현</summary>
<div markdown="1">

- 상황
  - Label을 Timer처럼 작동시키기 위해, 각 라면 데이터가 가진 시간을 분/초로 계산 후 작성
- 해결
  - 데이터에 저장된 시간을 보여주는 메서드, play 버튼을 누르면 1초씩 낮춰지는 메서드 모두 작성
  - 코드
        
```swift
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
                                
                    // 레이블 표시
        
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
```
        
```swift
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
```
        
```swift
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
```

</div>
</details>

<details>
<summary>addsubview로 분할된 view 구조에서 키보드 소환</summary>
<div markdown="1">

- 상황:
  - 각 라면마다 타이머를 보여주기 위해 새로운 view load 필요
  - Modal present로 view 이동 시 다른 라면을 선택하기 위해 view가 다시 전환되는 사용성 저하 발생
  - view.addSubview를 이용해 하위에 view 삽입
- 문제발생:
  - 메모를 위해 가상키보드 작동 시 view가 상위로 이동할 필요 대두
  - 가상키보드는 view의 frame을 바꾸는 방식으로 작동
  - 상위 collectionView와 하위 타이머 View의 중첩 frame으로 인해 적절한 화면 이동 실패
- 해결:
  - IQKeyboardManagerSwift 라이브러리 사용
        
```swift
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                
                IQKeyboardManager.shared.enable = true
                IQKeyboardManager.shared.enableAutoToolbar = false
                IQKeyboardManager.shared.shouldResignOnTouchOutside = true
                IQKeyboardManager.shared.keyboardDistanceFromTextField = 50
           
                return true
            }
```

</div>
</details>    
    
<details>
<summary>북마크 지정</summary>
<div markdown="1">

- 문제 발생:
  - 검색 화면에서 북마크 지정 시 CoreData에 저장, 이후 메인 화면에서도 연동 필요
- 해결:
  - 라면 리스트를 불러오는 Data에 고유 number와 bookmark 항목 추가
  - 북마크 버튼이 눌리면, 해당 cell의 number와 같은 데이터를 찾아 bookmark를 true로 변경
  - 코드
            
```swift
            extension BookmarkPlusVC: CellButtonActionDelegate {
                func bookmarkButtonTapped(_ id: String) {
                    if let ramens = ramens,
                       let index = ramens.firstIndex(where: { $0.number == id }) {
                        ramens[index].bookmark.toggle()
                        
                        CoreDataManager.shared.updateRamenData(newRamenData: ramens[index]) {
                            DispatchQueue.main.async { [weak self] in
                                guard let self = self else { return }
                                self.ramens = ramens
                                self.tableView.reloadData()
            				}
            		}
            }
```

</div>
</details> 

<details>
<summary>저장된 bookmark list 순서 변경</summary>
<div markdown="1">

- 문제 발생:
  - 검색 화면에서 bookmark list의 순서를 변경할 시 collectionView에도 연동되야 할 필요
- 해결:
  - 라면 리스트를 불러오는 Data에 order 항목 추가
  - 북마크가 체크되면 order 숫자를 올리고, 해제하면 order 숫자를 내리는 방식 채택
  - Coredata를 불러올 때 order 순으로 정렬
  - 코드
        
```swift
        // MARK: - [Read] 코어데이터에 저장된 데이터 모두 읽어오기
        func getRamenListFromCoreData() -> [RamenData] {
                var ramenList: [RamenData] = []
                if let context = context {
                    let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
                    let orderSort = NSSortDescriptor(key: "order", ascending: true)
                    request.sortDescriptors = [orderSort]            
                    do {
                        if let fetchedToDoList = try context.fetch(request) as? [RamenData] {
                            ramenList = fetchedToDoList
                        }
                    } catch {
                        print("가져오는 것 실패")
                    }
                }
                return ramenList
            }
```
        
```swift
        // MARK: - [Update] 코어데이터에서 데이터 수정하기 (일치하는 데이터 찾아서 ===> 수정)
                func updateRamenData(newRamenData: RamenData, completion: @escaping () -> Void) {
                    guard let data = newRamenData.number else {
                        completion()
                        return
                    }
                    
                    if let context = context {
                        let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
                        request.predicate = NSPredicate(format: "number = %@", data)
        
                        do {
                            if let fetchedRamenList = try context.fetch(request) as? [RamenData] {
                                if var targetRamen = fetchedRamenList.first {
        
                                    targetRamen = newRamenData
                                    let orderSort = NSSortDescriptor(key: "order", ascending: true)
                                    request.sortDescriptors = [orderSort]
                                    appDelegate?.saveContext()
                                }
                            }
                            completion()
                        } catch {
                            print("지우는 것 실패")
                            completion()
                        }
                    }
                }
```
        
```swift
        // MARK: - tableview move / drag / drop delegate
            
            func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
                
                guard let ramens = ramens else { return }
                
                if sourceIndexPath.row > destinationIndexPath.row {
                    for i in destinationIndexPath.row..<sourceIndexPath.row {
                        ramens[i].setValue(i+1, forKey: "order")
                    }
                    ramens[sourceIndexPath.row].setValue(destinationIndexPath.row, forKey: "order")
                }
                if sourceIndexPath.row < destinationIndexPath.row {
                    for i in sourceIndexPath.row + 1...destinationIndexPath.row {
                        ramens[i].setValue(i-1, forKey: "order")
                    }
                    ramens[sourceIndexPath.row].setValue(destinationIndexPath.row, forKey: "order")
                }
                print(ramens)
            }
```
</div>
</details>

    
