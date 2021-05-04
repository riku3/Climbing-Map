//
//  SearchTableViewController.swift
//  Climbing-Map
//
//  Created by riku on 2021/04/28.
//

import UIKit
import MapKit

class SearchTableViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var tableview: UITableView!
    
    var sectionTitles: Array<String> = ["地名","岩","課題"]
    
    var areaNames: Array<String> = []
    var rockNames: Array<String> = []
    var projectNames: Array<String> = []
    private var searchResultArea: Array<String> = []
    private var searchResultRock: Array<String> = []
    private var searchResultProject: Array<String> = []
    private var longitudeList: Array<Double> = []
    private var latitudeList: Array<Double> = []
    
    private var isRequesting = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultArea = areaNames
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
            row = searchResultArea.count
        case 1:
            row = searchResultRock.count
        case 2:
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
            cell.textLabel?.text = self.searchResultArea[indexPath.row]
        case 1:
            cell.textLabel?.text = self.searchResultRock[indexPath.row]
        case 2:
            cell.textLabel?.text = self.searchResultProject[indexPath.row]
        default:
            break
        }
        return cell
    }
    
    // セルタップ
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let presentVC = self.presentingViewController as! MapViewController
        switch indexPath.section {
        case 0:
            let row = indexPath.row
            presentVC.searchName = areaNames[row]
            presentVC.searchLongitude = longitudeList[row]
            presentVC.searchlatitude = latitudeList[row]
            presentVC.isSearchArea = true
        case 1:
            presentVC.searchName = rockNames[indexPath.row]
            presentVC.isSearchArea = false
        case 2:
            presentVC.searchName = projectNames[indexPath.row]
            presentVC.isSearchArea = false
        default:
            break
        }
        dismiss(animated: true){
            NotificationCenter.default.post(name: .searchCellTapped, object: nil)
        }
    }
}

extension SearchTableViewController: UISearchBarDelegate {
    
    func searchNames(searchText: String) {
        
        // 初期化
        searchResultArea = []
        areaNames = []
        longitudeList = []
        latitudeList = []
        
        let presentVC = self.presentingViewController as! MapViewController
        let region = MKCoordinateRegion(center: presentVC.mapView.userLocation.coordinate, latitudinalMeters: 1000.0, longitudinalMeters: 1000.0)
        
        if !isRequesting {
            isRequesting = true
            Map.search(query: searchText, region: region) { (result) in
                switch result {
                case .success(let mapItems):
                    var count = 0
                    for map in mapItems {
                        // 検索結果の上限5に指定
                        guard  count < 5 else {
                            break
                        }
                        print("name: \(map.name ?? "no name")")
                        print("coordinate: \(map.placemark.coordinate.longitude) \(map.placemark.coordinate.latitude)")
                        self.areaNames.append(map.name!)
                        self.longitudeList.append(map.placemark.coordinate.longitude)
                        self.latitudeList.append(map.placemark.coordinate.latitude)
                        count += 1
                    }
                    self.searchResultArea = self.areaNames
                    self.tableview.reloadData()
                case .failure(let error):
                    print("error \(error.localizedDescription)")
                }
                self.isRequesting = false
            }
        }
        
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
        searchNames(searchText: searchBar.text! as String)
    }
    // キャンセルのタップを検知
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
}

//extension SearchTableViewController {
//    // 強制的にdismissした際に遷移元を呼び出す
//    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
//        super.dismiss(animated: flag, completion: completion)
//        guard let presentationController = presentationController else {
//            return
//        }
//        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
//    }
//}

struct Map {
    enum Result<T> {
        case success(T)
        case failure(Error)
    }

    static func search(query: String, region: MKCoordinateRegion? = nil, completionHandler: @escaping (Result<[MKMapItem]>) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query

        if let region = region {
            request.region = region
        }

        MKLocalSearch(request: request).start { (response, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            completionHandler(.success(response?.mapItems ?? []))
        }
    }
}
