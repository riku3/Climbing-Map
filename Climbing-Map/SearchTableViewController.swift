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
    
//    var names: Array<String> = []
//    private var searchResult: Array<String> = []
    var sectionTitles: Array<String> = ["岩","課題"]
    var rockNames: Array<String> = []
    var projectNames: Array<String> = []
    private var searchResultRock: Array<String> = []
    private var searchResultProject: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultRock = rockNames
        searchResultProject = projectNames
        searchBar.delegate = self
    }
    
    // セクション数
    override func numberOfSections(in tableView: UITableView) -> Int {
        sectionTitles.count
    }
    
    // セクションのタイトル
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section] as String?
    }
    
    // セクション毎のセル数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var row: Int
        switch section {
        case 0:
            row = searchResultRock.count
        case 1:
            row = searchResultProject.count
        default:
            row = 0
        }
        return row
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath)

        switch indexPath.section {
        case 0:
            cell.textLabel?.text = self.searchResultRock[indexPath.row]
        case 1:
            cell.textLabel?.text = self.searchResultProject[indexPath.row]
        default:
            break
        }
        return cell
    }
}

extension SearchTableViewController: UISearchBarDelegate {
    
    func searchNames(searchText: String) {
        //要素を検索する
        if searchText != "" {
            searchResultRock = rockNames.filter { rockName in
                return rockName.contains(searchText)
            } as Array
            searchResultProject = projectNames.filter { projectName in
                return projectName.contains(searchText)
            } as Array
        } else {
            //渡された文字列が空の場合は全てを表示
            searchResultRock = rockNames
            searchResultProject = projectNames
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
