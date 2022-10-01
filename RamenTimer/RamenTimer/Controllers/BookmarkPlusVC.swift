//
//  BookmarkPlusVC.swift
//  RamenTimer
//
//  Created by 이형주 on 2022/08/30.
//

import UIKit

class BookmarkPlusVC: UIViewController  {

    
    // MARK: -  Properties
    let tableView = UITableView()
    var ramens: [RamenData]?
    var searchedArray: [RamenData] = []
    var bookmarkedRamens: [RamenData]?
    var isFiltering: Bool = false {
        didSet {
            updateBookmarkedRamenArray()
        }
    }
    var isFilteringStart: Bool = false
    var ramenForBookmarkButton: RamenData?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        setupNavigationItem()
        setupTableView()
        setupTableViewConstraints()
        setupSearchbar()
        tableView.isUserInteractionEnabled = true
        tableView.allowsSelectionDuringEditing = true
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        ramens = CoreDataManager.shared.getRamenListFromCoreData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateBookmarkedRamenArray()
    }
    
    // MARK: - Helpers
    
    func updateBookmarkedRamenArray() {
        self.bookmarkedRamens = self.ramens?.filter( { $0.bookmark == true })

    }
    
    func setupSearchbar() {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))
        navigationItem.titleView = searchBar
        searchBar.placeholder = "즐겨찾기에 추가할 라면을 검색하세요."
        searchBar.delegate = self
    }
        
    func setupNavigationItem() {
        navigationItem.largeTitleDisplayMode = .never


    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BookmarkPlusTableViewCell.self, forCellReuseIdentifier: cellID.forTableView)
    }
    
    func setupBookmarkButton(ramens: [RamenData]?, indexPath: IndexPath, cell: BookmarkPlusTableViewCell) {
        if let ramens = ramens {
            if ramens[indexPath.row].bookmark == true {
                cell.bookmarkButton.setImage(UIImage(systemName: ImageSystemNames.starFill), for: .normal)
            } else {
                cell.bookmarkButton.setImage(UIImage(systemName: ImageSystemNames.star), for: .normal)
            }
        }
        
        
    }

    func setupTableViewConstraints() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupTimerLabel(ramens: [RamenData]? ,indexPath: IndexPath, cell: BookmarkPlusTableViewCell) {
        if let ramens = ramens {
            let cellModel = ramens[indexPath.row]
            
            guard let settingTimer = cellModel.settingTime,
                  let intSettingTimer = Int(settingTimer) else { return }
            let minutes: Int = intSettingTimer / 60
            let seconds: Int = intSettingTimer - (minutes * 60)
            let mins = minutes
            let secs = seconds
            
            if mins == 0 && secs == 0 {
                cell.timeLabel.text = "00:00"
            } else if secs < 10 && mins < 10 {
                cell.timeLabel.text = "0\(mins):0\(secs)"
            } else if mins < 10 {
                cell.timeLabel.text = "0\(mins):\(secs)"
            } else if mins == 10 && secs < 10 {
                cell.timeLabel.text = "\(mins):0\(secs)"
            } else {
                cell.timeLabel.text = "\(mins):\(secs)"
            }        }
    }
    
    
    // MARK: - Actions

    @objc func bookmarkButtonTappedForBookmarked(_ sender: UIButton) {
        let contentView = sender.superview?.superview
        guard let cell = contentView?.superview as? UITableViewCell else { return }
        let indexPath = tableView.indexPath(for: cell)
        guard let bookmarkedRamens = bookmarkedRamens,
              let index = indexPath else { return }

        bookmarkedRamens[index.row].bookmark = !bookmarkedRamens[index.row].bookmark
        print("DEBUG: 북마크드라멘즈에서 눌려진 북마크 셀 \n \(bookmarkedRamens[index.row])")
        CoreDataManager.shared.updateRamenData(newRamenData: bookmarkedRamens[index.row], completion: {
        })
        

    }
    
    @objc func bookmarkButtonTappedForSearched(_ sender: UIButton) {
        let contentView = sender.superview?.superview
        guard let cell = contentView?.superview as? UITableViewCell else { return }
        let indexPath = tableView.indexPath(for: cell)
        guard let index = indexPath else { return }

        searchedArray[index.row].bookmark = !searchedArray[index.row].bookmark
        print("DEBUG: 서치라멘즈에서 눌려진 북마크 셀 \n \(searchedArray[index.row])")
        CoreDataManager.shared.updateRamenData(newRamenData: searchedArray[index.row], completion: {
        })
        
    }

}

// MARK: - tableView dataSource extension
extension BookmarkPlusVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFilteringStart == true {
            return ramens?.count ?? 0
        } else {
            return self.isFiltering ? searchedArray.count : (bookmarkedRamens?.count ?? 0)

        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID.forTableView) as! BookmarkPlusTableViewCell
        
        if self.isFilteringStart == true && self.isFiltering == false {
            if let ramens = ramens,
               let imageTitle = ramens[indexPath.row].title {
                cell.ramenImage.image = UIImage(named: imageTitle)
                cell.ramenTitleLabel.text = imageTitle
                setupTimerLabel(ramens: ramens ,indexPath: indexPath, cell: cell)
                setupBookmarkButton(ramens: ramens, indexPath: indexPath, cell: cell)
            }
        } else if self.isFilteringStart == false && self.isFiltering == true {
            
            if let imageTitle = searchedArray[indexPath.row].title {
                cell.ramenImage.image = UIImage(named: imageTitle)
                cell.ramenTitleLabel.text = imageTitle
            }
            setupTimerLabel(ramens: searchedArray , indexPath: indexPath, cell: cell)
            setupBookmarkButton(ramens: searchedArray, indexPath: indexPath, cell: cell)
            
            cell.bookmarkButton.addTarget(self, action: #selector(bookmarkButtonTappedForSearched(_:)), for: .touchUpInside)
            cell.cellDelegate = self
        } else if self.isFilteringStart == false && self.isFiltering == false {
            if let bookmarkedRamens = bookmarkedRamens,
               let imageTitle = bookmarkedRamens[indexPath.row].title {
                cell.ramenImage.image = UIImage(named: imageTitle)
                cell.ramenTitleLabel.text = imageTitle
                setupTimerLabel(ramens: bookmarkedRamens ,indexPath: indexPath, cell: cell)
                setupBookmarkButton(ramens: bookmarkedRamens, indexPath: indexPath, cell: cell)
//                cell.bookmarkButton.addTarget(self, action: #selector(bookmarkButtonTappedForBookmarked(_:)), for: .touchUpInside)
            }
            cell.cellDelegate = self
        }
        
        return cell
    }

}

// MARK: - UITableViewDelegate

extension BookmarkPlusVC: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        

        
        if isFiltering == false {
            let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { action, view, completionHandler in
                guard let bookmarkedRamens = self.bookmarkedRamens else { return }
                let ramen = bookmarkedRamens[indexPath.row]
                ramen.bookmark = false
                CoreDataManager.shared.updateRamenData(newRamenData: ramen, completion: {
                    print("삭제성공")
                    self.updateBookmarkedRamenArray()
                    self.tableView.reloadData()
                })
                
                completionHandler(true)
                
            }
            deleteAction.backgroundColor = .red
            let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
            swipeActions.performsFirstActionWithFullSwipe = false
            return swipeActions
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // delete 모드로 수정
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return UITableViewCell.EditingStyle.delete
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//    }
    


    
// MARK: - tableview move / drag / drop delegate
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        

            guard let bookmarked = bookmarkedRamens else { return }
            let moveCell = bookmarked[sourceIndexPath.row]
            
            


        
        
        
        // 원래 getRamenArray()로 데이터를 받는데 함수로 받으면 mutate가 안된다고 함. 아놔.
//        CoreDataManager.shared.getRamenListFromCoreData().remove(at: sourceIndexPath.row)
//        self.ramensDataManager.ramens.insert(moveCell, at: destinationIndexPath.row)
    }

    
}

extension BookmarkPlusVC: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}

extension BookmarkPlusVC: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    

}


// MARK: - 서치바 익스텐션
extension BookmarkPlusVC: UISearchBarDelegate {
    // 서치바에서 검색을 시작할 때 호출
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.isFilteringStart = true
        self.isFiltering = false
        
        self.tableView.reloadData()
        navigationItem.rightBarButtonItem = .none
        searchBar.showsCancelButton = true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.isFilteringStart = false
        self.isFiltering = true

        guard let text = searchBar.text?.lowercased(),
              let ramens = ramens else { return }
        
        self.searchedArray = ramens.filter {
            $0.title?.localizedCaseInsensitiveContains(text) ?? false }
        print("DEBUG: 검색한 데이터들 \(searchedArray)")
        self.tableView.reloadData()
    }
        // 서치바에서 검색버튼을 눌렀을 때 호출
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let text = searchBar.text?.lowercased(),
              let ramens = ramens else { return }
        
        self.searchedArray = ramens.filter {
            $0.title?.localizedCaseInsensitiveContains(text) ?? false }
    }
        
        // 서치바에서 취소 버튼을 눌렀을 때 호출
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.text = ""
            searchBar.resignFirstResponder()
            self.isFiltering = false
//            navigationItem.rightBarButtonItem = self.editButtonItem
            searchBar.showsCancelButton = false
            self.tableView.reloadData()
        }
        // 서치바 검색이 끝났을 때 호출
        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {

            self.tableView.reloadData()
            
        }
}



extension BookmarkPlusVC: CellButtonActionDelegate {
    func bookmarkButtonTapped() {
        print("눌렸당")
        
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadData()
            }
    }
    
    
//    @objc func bookmarkButtonTappedForBookmarked(_ sender: UIButton) {
//        let contentView = sender.superview?.superview
//        guard let cell = contentView?.superview as? UITableViewCell else { return }
//        let index = tableView.indexPath(for: cell)
//        guard let bookmarkedRamens = bookmarkedRamens,
//              let index = index else { return }
//
//        bookmarkedRamens[index.row].bookmark = !bookmarkedRamens[index.row].bookmark
//        print("DEBUG: 북마크드라멘즈에서 눌려진 북마크 셀 \n \(bookmarkedRamens[index.row])")
//        CoreDataManager.shared.updateRamenData(newRamenData: bookmarkedRamens[index.row], completion: {
//        })
//
    
    
    
}
