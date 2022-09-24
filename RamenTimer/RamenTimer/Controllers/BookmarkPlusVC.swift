//
//  BookmarkPlusVC.swift
//  RamenTimer
//
//  Created by 이형주 on 2022/08/30.
//

import UIKit

class BookmarkPlusVC: UIViewController  {


    let tableView = UITableView()
    let ramensDataManager = RamensDataManager()
    var searchedArray: [Ramen] = []
    var isFiltering: Bool = false

    
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
    }
    
    func setupSearchbar() {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))
        navigationItem.titleView = searchBar
        searchBar.placeholder = "즐겨찾기에 추가할 라면을 검색하세요"
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

    func setupTableViewConstraints() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
// MARK: - 테이블뷰 익스텐션

extension BookmarkPlusVC: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "삭제") { action, view, completionHandler in
        }
        deleteAction.backgroundColor = .red
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeActions.performsFirstActionWithFullSwipe = false
        return swipeActions
        
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
    
}

extension BookmarkPlusVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isFiltering ? searchedArray.count : ramensDataManager.getRamenArray().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID.forTableView) as! BookmarkPlusTableViewCell
        if self.isFiltering {
            cell.ramenImage.image = searchedArray[indexPath.row].image
//            cell.bookmarButtonAction = { [unowned self] in
//                print("hi")
//            }
            cell.cellDelegate = self
        } else {
            cell.ramenImage.image = ramensDataManager.getRamenArray()[indexPath.row].image
//            cell.bookmarButtonAction = { [unowned self] in
//                print("hi")
//            }
            cell.cellDelegate = self
        }
        return cell
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moveCell = self.ramensDataManager.getRamenArray()[sourceIndexPath.row]
        // 원래 getRamenArray()로 데이터를 받는데 함수로 받으면 mutate가 안된다고 함. 아놔.
        self.ramensDataManager.ramens.remove(at: sourceIndexPath.row)
        self.ramensDataManager.ramens.insert(moveCell, at: destinationIndexPath.row)
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
        self.isFiltering = true
        self.tableView.reloadData()
        navigationItem.rightBarButtonItem = .none
        searchBar.showsCancelButton = true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text?.lowercased() else { return }
        
        self.searchedArray = ramensDataManager.getRamenArray().filter {
            $0.title?.localizedCaseInsensitiveContains(text) ?? false }
        self.tableView.reloadData()
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
    }
}
