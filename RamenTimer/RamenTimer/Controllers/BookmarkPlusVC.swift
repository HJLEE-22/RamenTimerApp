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
        updateBookmarkedRamenArray()
        if let ramens = ramens {
            print("DEBUG: maxRamen \(ramens.max(by: { $0.order < $1.order }))")

        }
    }
    
    
    // MARK: - Helpers
    
    func updateBookmarkedRamenArray() {
        ramens = getRamensData().filter({ $0.bookmark == true })
    }
    
    func getRamensData() ->[RamenData] {
        return CoreDataManager.shared.getRamenListFromCoreData()
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
        tableView.allowsSelection = false
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
        
        
    
}

// MARK: - tableView dataSource extension
extension BookmarkPlusVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ramens?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID.forTableView) as! BookmarkPlusTableViewCell
        
        guard let ramens = self.ramens else { return BookmarkPlusTableViewCell() }
        cell.updateRamenCell(ramenData: ramens[indexPath.row], isDragInteractionEnabled: tableView.dragInteractionEnabled)
        cell.cellDelegate = self
        
        return cell
    }


    
}

// MARK: - UITableViewDelegate

extension BookmarkPlusVC: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

            let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { action, view, completionHandler in
                guard let ramens = self.ramens else { return }
                let ramen = ramens[indexPath.row]
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
        getRamenDataDependingText(searchBar: searchBar)
        self.tableView.reloadData()
        navigationItem.rightBarButtonItem = .none
        searchBar.showsCancelButton = true
        tableView.dragInteractionEnabled = false
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getRamenDataDependingText(searchBar: searchBar)
        self.tableView.reloadData()
        tableView.dragInteractionEnabled = false

    }
    
    // 서치바에서 검색버튼을 눌렀을 때 호출
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getRamenDataDependingText(searchBar: searchBar)
        self.tableView.reloadData()
        searchBar.resignFirstResponder()
        tableView.dragInteractionEnabled = false

    }
    
    // 서치바에서 취소 버튼을 눌렀을 때 호출
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

        searchBar.text = ""
        updateBookmarkedRamenArray()
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        self.tableView.reloadData()
        tableView.dragInteractionEnabled = true

    }
    
    // 서치바 검색이 끝났을 때 호출
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.tableView.reloadData()
    }
    
    func getRamenDataDependingText(searchBar: UISearchBar) {
        if searchBar.text!.isEmpty {
            ramens = getRamensData()
        } else {
            ramens = getRamensData().filter({ $0.title!.contains(searchBar.text!) })
        }
    }
}

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
//                    self.updateBookmarkedRamenArray()

                    
                    // 서치바가 작동중일때랑 아닐때?

                    
                }
            }
            // 새로 추가되는 라면 리스트 하단으로 이동하려 했던 코드...
//            if ramens[index].bookmark == true {
//                guard let maxRamenOrder = ramens.max(by: { $0.order < $1.order} )?.order else { return }
//                ramens[index].order += maxRamenOrder + 1
//                print("DEBUG: total Ramens \(ramens)")
//            }
        }
    }
}



