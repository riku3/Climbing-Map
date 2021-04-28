//
//  SearchTableViewController.swift
//  Climbing-Map
//
//  Created by riku on 2021/04/28.
//

import UIKit

class SearchTableViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var tableview: UITableView!
    
    var names: Array<String> = []
    private var searchResult: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResult = names
        searchBar.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResult.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath)
        cell.textLabel?.text = self.searchResult[indexPath.row]
        return cell
    }
}

extension SearchTableViewController: UISearchBarDelegate {
    
    func searchNames(searchText: String) {
        //要素を検索する
        if searchText != "" {
            searchResult = names.filter { name in
                return name.contains(searchText)
            } as Array
        } else {
            //渡された文字列が空の場合は全てを表示
            searchResult = names
        }
        //tableViewを再読み込みする
        tableview.reloadData()
    }
    
    // 検索文言の入力毎に呼ばれる
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchNames(searchText: searchText)
    }
    
    // Searchボタンが押されると呼ばれる
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        //検索する
        searchNames(searchText: searchBar.text! as String)
    }
    // キャンセルのタップを検知
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
}
