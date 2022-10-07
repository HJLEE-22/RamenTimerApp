//
//  SceneDelegate.swift
//  RamenTimer
//
//  Created by 이형주 on 2022/08/27.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var ramenForDecoder: [RamenModelCodable]?

    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) ->UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        return nav
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        

        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)

        // 탭바컨트롤러의 생성
        let tabBarVC = UITabBarController()
        
        // 첫번째 화면은 네비게이션컨트롤러로 만들기 (기본루트뷰 설정)
        let vc1 = UINavigationController(rootViewController: BookmarkVC())
        let vc2 = UINavigationController(rootViewController: RamenSearchVC())
//        let vc3 = RandomVC()
        
        // 탭바 이름들 설정
        vc1.title = "즐겨찾기"
        vc2.title = "라면찾기"
//        vc3.title = "랜덤찾기"

        // 탭바로 사용하기 위한 뷰 컨트롤러들 설정
        tabBarVC.setViewControllers([vc1, vc2], animated: false)
//        tabBarVC.setViewControllers([vc1, vc2, vc3], animated: false)
        tabBarVC.modalPresentationStyle = .fullScreen
        tabBarVC.tabBar.backgroundColor = .white
        tabBarVC.tabBar.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)

        
        // 탭바 이미지 설정 (이미지는 애플이 제공하는 것으로 사용)
        guard let items = tabBarVC.tabBar.items else { return }
        
        items[0].image = UIImage(systemName: "star.circle")
        items[0].selectedImage = UIImage(systemName: "star.circle.fill")
        items[1].image = UIImage(systemName: "magnifyingglass.circle")
        items[1].selectedImage = UIImage(systemName: "magnifyingglass.circle.fill")
//        items[2].image = UIImage(systemName: "die.face.5") // di.face.5.fill
            
        // 기본루트뷰를 탭바컨트롤러로 설정⭐️⭐️⭐️
        window?.rootViewController = tabBarVC
        window?.makeKeyAndVisible()
        
        
        
        // MARK: - JSON decoder part
        

        
        let existedData = CoreDataManager.shared.getRamenListFromCoreData()

        
        let fileName = "RamensList"
        let fileType = "json"
        let jsonPath = Bundle.main.path(forResource: fileName, ofType: fileType)
        
        let data = loadJsonData(fileLocation: jsonPath ?? "" )
        
        guard let jsonDataLoaded = data else { return }
        
        if UserDefaults.standard.bool(forKey: "launchedBefore") == true {

            print("존재데이터 : \(existedData)")

        } else {
            do {
                self.ramenForDecoder = try JSONDecoder().decode([RamenModelCodable].self, from: jsonDataLoaded)
                if let ramenForDecoder = ramenForDecoder {
                    ramenForDecoder.forEach {
                        CoreDataManager.shared.saveRamenData(ramens: $0, completion: {
                        })
                    }
                    UserDefaults.standard.set(true, forKey: "launchedBefore")
                    print("DEBUG: success to save")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }

    func loadJsonData(fileLocation: String) -> Data? {
        let data = try? String(contentsOfFile: fileLocation).data(using: .utf8)
        return data
    }
    
    
    
    
}

