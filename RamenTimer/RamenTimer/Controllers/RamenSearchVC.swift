//
//  RamenSearchVC.swift
//  RamenTimer
//
//  Created by 이형주 on 2022/08/27.
//

import UIKit


class RamenSearchVC: UIViewController {


    let ramensDataManager = RamensDataManager()
    lazy var searchController = UISearchController(searchResultsController: nil)
    var isFiltering = false
    var searchedArray: [Ramen] = []
    
    private var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: 130, height: 130)
        // 아이템 사이 간격 설정
        flowLayout.minimumInteritemSpacing = 0
        // 아이템 위아래 사이 간격 설정
        flowLayout.minimumLineSpacing = 0
        
        // 컬렉션뷰의 속성에 할당
        cv.collectionViewLayout = flowLayout
        return cv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupSearchbarConstraints()
        setupNaviBar()
        setupCollectionView()
        setupCollectionViewConstraints()
        view.backgroundColor = .white
        self.navigationItem.searchController = searchController
        
    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    // MARK: - 네비바 셋업
    func setupNaviBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()  // 불투명으로
        //appearance.backgroundColor = .brown     // 색상설정
        
        //appearance.configureWithTransparentBackground()  // 투명으로
        
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        title = "라면찾기"

    }
    
    
    // MARK: - 서치바 셋업
    func setupSearchController() {
//        searchController.searchBar.frame = CGRect(x: 0, y: 0, width: self.view.safeAreaLayoutGuide.layoutFrame.size.width - 20, height: 30)
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "라면을 검색하세요."
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.autocorrectionType = .no

        
    }
    
    func setupSearchbarConstraints() {
        view.addSubview(searchController.searchBar)
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchController.searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            searchController.searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchController.searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchController.searchBar.heightAnchor.constraint(equalToConstant: 30)

        ])
        
        
    }

    // MARK: - 콜렉션뷰 셋업
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        
        collectionView.register(RamenSearchCollectionViewCell.self, forCellWithReuseIdentifier: "RamenSearchCellID")
    }

    func setupCollectionViewConstraints() {
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)


            
        ])
    }
    

}



// MARK: - 서치바 익스텐션


extension RamenSearchVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
}

extension RamenSearchVC: UISearchBarDelegate {
    
    
    // 서치바에서 검색을 시작할 때 호출
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.isFiltering = true
        self.collectionView.reloadData()
        searchBar.showsCancelButton = true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text?.lowercased() else { return }
        
        self.searchedArray = ramensDataManager.getRamenArray().filter {
            $0.title?.localizedCaseInsensitiveContains(text) ?? false }
        self.collectionView.reloadData()
    }
        // 서치바에서 검색버튼을 눌렀을 때 호출
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let text = searchBar.text?.lowercased() else { return }
        
        self.searchedArray = ramensDataManager.getRamenArray().filter {
            $0.title?.localizedCaseInsensitiveContains(text) ?? false }
    }
        
        // 서치바에서 취소 버튼을 눌렀을 때 호출
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.text = ""
            searchBar.resignFirstResponder()
            self.isFiltering = false
//            navigationItem.rightBarButtonItem = self.editButtonItem
            searchBar.showsCancelButton = false
            self.collectionView.reloadData()
        }
        // 서치바 검색이 끝났을 때 호출
        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            self.collectionView.reloadData()
        }
}


// MARK: - 컬렉션뷰 익스텐션

extension RamenSearchVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ramenSearchDetailVC = RamenSearchDetailVC()
        
        if isFiltering {
            ramenSearchDetailVC.ramenData = searchedArray[indexPath.row]
        } else {
            ramenSearchDetailVC.ramenData = ramensDataManager.getRamenArray()[indexPath.row]
        }
        self.present(ramenSearchDetailVC, animated: true)
        
    }
    
    
}

extension RamenSearchVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return isFiltering ? searchedArray.count : ramensDataManager.getRamenArray().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RamenSearchCellID", for: indexPath) as! RamenSearchCollectionViewCell
        if !isFiltering {
            cell.imageView.image = ramensDataManager.getRamenArray()[indexPath.row].image
            
        } else {
            cell.imageView.image = self.searchedArray[indexPath.row].image
        }
        

        return cell
    }
    
    
    
    
    
}
