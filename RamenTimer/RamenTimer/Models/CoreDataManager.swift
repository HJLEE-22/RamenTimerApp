//
//  CoreDataManager.swift
//  RamenTimer
//
//  Created by 이형주 on 2022/09/06.
//

import UIKit
import CoreData

class CoreDataManager {
    // 싱글톤으로 만들기
    static let shared = CoreDataManager()
    private init() {}
    
    // 앱 델리게이트
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    // 임시저장소
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    class func getContext () -> NSManagedObjectContext {
        return DatabaseController.persistentContainer.viewContext
    }
    
    // 엔터티 이름 (코어데이터에 저장된 객체)
    let modelName: String = "RamenData"
    
    
    // MARK: - Core Data Saving support
    class func saveContext() {
        let context = self.getContext()
        if context.hasChanges {
            do {
                try context.save()
                print("Data Saved to Context")
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - [Read] 코어데이터에 저장된 데이터 모두 읽어오기
        func getRamenListFromCoreData() -> [RamenData] {
            var ramenList: [RamenData] = []
            // 임시저장소 있는지 확인
            if let context = context {
                // 요청서
                let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
                // 정렬순서를 정해서 요청서에 넘겨주기
//                let dateOrder = NSSortDescriptor(key: "date", ascending: false)
//                request.sortDescriptors = [dateOrder]
                let numberOrder = NSSortDescriptor(key: "number", ascending: false)
                request.sortDescriptors = [numberOrder]
                
                do {
                    // 임시저장소에서 (요청서를 통해서) 데이터 가져오기 (fetch메서드)
                    if let fetchedToDoList = try context.fetch(request) as? [RamenData] {
                        ramenList = fetchedToDoList
                    }
                } catch {
                    print("가져오는 것 실패")
                }
            }
            
            return ramenList
        }
    
    // MARK: - [Create] 코어데이터에 데이터 생성하기
    func saveRamenData(number: Int16, title: String?, bookmark: Bool = false, brand: String?, memo: String?, water: Int16, settingTime: Int16, spicyLevel: Int16, suggestedTime: Int16, color: String?  , completion: @escaping () -> Void) {
            // 임시저장소 있는지 확인
            if let context = context {
                // 임시저장소에 있는 데이터를 그려줄 형태 파악하기
                if let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) {
                    
                    // 임시저장소에 올라가게 할 객체만들기 (NSManagedObject ===> ToDoData)
                    if let ramenData = NSManagedObject(entity: entity, insertInto: context) as? RamenData {
                        
                        // MARK: - ToDoData에 실제 데이터 할당 ⭐️

                        ramenData.number = number
                        ramenData.title = title
                        ramenData.bookmark = bookmark
                        ramenData.brand = brand
                        ramenData.memo = memo
                        ramenData.water = water
                        ramenData.settingTime = settingTime
                        ramenData.spicyLevel = spicyLevel
                        ramenData.suggestedTime = suggestedTime
                        ramenData.color = color
                        
                        appDelegate?.saveContext()
                    }
                }
            }
            completion()
        }
    
    // MARK: - [Delete] 코어데이터에서 데이터 삭제하기 (일치하는 데이터 찾아서 ===> 삭제)
        func deleteRamenData(data: RamenData, completion: @escaping () -> Void) {
            
            // 임시저장소 있는지 확인
            if let context = context {
                // 요청서
                let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
                // 단서 / 찾기 위한 조건 설정
                request.predicate = NSPredicate(format: "number = %@", data.number as CVarArg)
                
                do {
                    // 요청서를 통해서 데이터 가져오기 (조건에 일치하는 데이터 찾기) (fetch메서드)
                    if let fetchedToDoList = try context.fetch(request) as? [RamenData] {
                        
                        // 임시저장소에서 (요청서를 통해서) 데이터 삭제하기 (delete메서드)
                        if let targetRamen = fetchedToDoList.first {
                            context.delete(targetRamen)
                            
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
    
    // MARK: - [Update] 코어데이터에서 데이터 수정하기 (일치하는 데이터 찾아서 ===> 수정)
        func updateRamenData(newRamenData: RamenData, completion: @escaping () -> Void) {
            // 날짜 옵셔널 바인딩
//            guard let data = newRamenData.number else {
//                completion()
//                return
//            }
            
            // 임시저장소 있는지 확인p
            if let context = context {
                // 요청서
                let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
                // 단서 / 찾기 위한 조건 설정
                request.predicate = NSPredicate(format: "number = %@", newRamenData.number as CVarArg)
                
                do {
                    // 요청서를 통해서 데이터 가져오기
                    if let fetchedRamenList = try context.fetch(request) as? [RamenData] {
                        // 배열의 첫번째
                        if var targetRamen = fetchedRamenList.first {
                            
                            // MARK: - ToDoData에 실제 데이터 재할당(바꾸기) ⭐️
                            targetRamen = newRamenData
                            
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
    
}
