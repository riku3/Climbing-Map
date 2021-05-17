//
//  MapViewController.swift
//  Climbing-Map
//
//  Created by riku on 2021/04/25.
//

import UIKit
import MapKit
import CoreLocation
import FloatingPanel
import Firebase

struct Rock {
    var id: Int
    var name: String
    var longitude: Double
    var latitude: Double
    var projects: [Project]
}
struct Project {
    var id: Int
    var name: String
    var grade: String
}

struct ServerMaintenanceConfig: Codable {
    let isMaintenance: Bool
    let title: String
    let message: String
}

struct ServerForceUpdateConfig: Codable {
    let isForceUpdate: Bool
    let forceVersion: String
    let title: String
    let message: String
}

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapTypeBtn: UIButton!
    
    var locationManager: CLLocationManager!
    var onceNowLocationFlag = true
    var fpc = FloatingPanelController()
    var rockList: [Rock] = []
    var isSearchArea = false
    var searchName = ""
    var searchLongitude: Double = 0.0
    var searchlatitude: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // メンテナンスモードチェック
        checkMaintenance()
        
        // セットアップ
        setUpMapData()
        setUpLocationManager()
        setUpBtn()
        
        // delegate
        locationManager.delegate = self
        mapView.delegate = self
        fpc.delegate = self
        searchBar.delegate = self
        
        // Notification
        NotificationCenter.default.addObserver(self, selector: #selector(searchCellTapped(notification:)), name: .searchCellTapped, object: nil)
    }
    
    @IBAction func tappedMapTypeBtn(_ sender: UIButton) {
        switch mapView.mapType {
        case .standard:
            // 3D Flyover+ラベル
            mapView.mapType = .hybridFlyover
        default:
            // 標準の地図
            mapView.mapType = .standard
        }
    }
    
    @IBAction func tappedLocationBtn(_ sender: UIButton) {
        // 現在地に移動
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1) // 0.01が距離の倍率
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: span)
        mapView.region = region
    }
    
    @IBAction func mapViewDidTap(sender: UITapGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.ended {
            fpc.hide()
        }
    }
    
    // メンテナンスモード・強制アップデートかチェックする
    private func checkMaintenance() {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0; // for test
        remoteConfig.configSettings = settings
        remoteConfig.fetch() { (status, error) -> Void in
            guard status == .success else {
                return
            }
            remoteConfig.activate() { [self] (changed, error) in
                // メンテナンス
                guard let maintenanceString = remoteConfig.configValue(forKey: "maintenance").stringValue else {
                    return
                }
                let maintenanceData = maintenanceString.data(using: .utf8)!
                let maintenanceDecoder = JSONDecoder()
                maintenanceDecoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let maintenance = try maintenanceDecoder.decode(ServerMaintenanceConfig.self, from: maintenanceData)
                    // メンテナンスモード中はアラートを表示
                    if maintenance.isMaintenance {
                        DispatchQueue.main.sync {
                            self.showMaintenanceAlert(maintenanceConfig: maintenance)
                        }
                    }
                } catch let error{
                    print(error)
                }
                
                // 強制アップデート
                guard let forceUpdateString = remoteConfig.configValue(forKey: "force_update").stringValue else {
                    return
                }
                let forceUpdatedata = forceUpdateString.data(using: .utf8)!
                let forceUpdateDecoder = JSONDecoder()
                forceUpdateDecoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let forceUpdate = try forceUpdateDecoder.decode(ServerForceUpdateConfig.self, from: forceUpdatedata)
                    
                    // バージョン比較
                    let configVerInt = versionToInt(forceUpdate.forceVersion)
                    let currentVerInt = versionToInt(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
)
                    // 強制アップデート中はアラートを表示し、Appstoreへの導線を表示
                    if forceUpdate.isForceUpdate && configVerInt > currentVerInt {
                        DispatchQueue.main.sync {
                            self.showForceUpdateAlert(forceUpdateConfig: forceUpdate)
                        }
                    }
                } catch let error{
                    print(error)
                }
            }
        }
    }
    
    // x.x.xの数値比較用
    private func versionToInt(_ ver: String) -> Int {
        let arr = ver.split(separator: ".").map { Int($0) ?? 0 }

        switch arr.count {
            case 3:
                return arr[0] * 1000 * 1000 + arr[1] * 1000 + arr[2]
            case 2:
                return arr[0] * 1000 * 1000 + arr[1] * 1000
            case 1:
                return arr[0] * 1000 * 1000
            default:
                assertionFailure("Illegal version string.")
                return 0
        }
    }
    
    // メンテナンスアラート表示
    private func showMaintenanceAlert(maintenanceConfig: ServerMaintenanceConfig) {
        let alertController = UIAlertController(
            title: maintenanceConfig.title,
            message: maintenanceConfig.message,
            preferredStyle: .alert
        )
        present(alertController, animated: true, completion: nil)
    }
    
    // 強制アップデートアラート表示
    private func showForceUpdateAlert(forceUpdateConfig: ServerForceUpdateConfig) {
        let alertController = UIAlertController(
            title: forceUpdateConfig.title,
            message: forceUpdateConfig.message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "アップデート", style: .default, handler: { Void in
            // TODO: AppStore公開後にappIDを入れる
//            guard let url = URL(string: "itms-apps://itunes.apple.com/app/id\(appID)") else { return }
            guard let url = URL(string: "itms-apps://itunes.apple.com/") else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        })
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // FireStoreからMapデータを取得
    private func setUpMapData() {
        let db = Firestore.firestore()
        db.collection("rocks").getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    // 必須項目
                    guard let projectDicList: [[String : Any]] = document.get("projects") as? [[String : Any]] else {
                        continue
                    }
                    
                    var projects: [Project] = []
                    
                    // 課題追加
                    for projectDic in projectDicList {
                        // 必須項目
                        guard let projectId = projectDic["id"] as? Int ,
                              let projectGrade = projectDic["grade"] as? String else {
                            continue
                        }
                        // デフォルト可項目
                        let projectName = projectDic["name"] as? String ?? "無題"
                        let project = Project(
                                        id: projectId,
                                        name: projectName,
                                        grade: projectGrade)
                        projects.append(project)
                    }
                    
                    // 課題数0の場合はスキップ、必須項目
                    guard projects.count != 0,
                          let rockId = document.get("id") as? Int,
                          let rockLongitude = document.get("longitude") as? Double,
                          let rockLatitude = document.get("latitude") as? Double
                          else {
                        continue
                    }
                    
                    // デフォルト可項目
                    let rockName = document.get("name") as? String ?? "無題"
                    // 岩追加
                    let rock = Rock(
                        id: rockId,
                        name: rockName,
                        longitude: rockLongitude,
                        latitude: rockLatitude,
                        projects: projects)
                    self.rockList.append(rock)
                }
                // ピンにセット
                setPinToMap()
            }
        }
    }
    
    // ロケーションマネージャーのセットアップ
    private func setUpLocationManager() {
        // ロケーションマネージャーのセットアップ
        locationManager = CLLocationManager()
        locationManager!.requestWhenInUseAuthorization()
    }
    // ボタンデザインの更新
    private func setUpBtn() {
        // マップタイプボタンのデザイン更新
        mapTypeBtn.layer.shadowColor = UIColor.black.cgColor
        mapTypeBtn.layer.shadowRadius = 2
        mapTypeBtn.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        mapTypeBtn.layer.shadowOpacity = 0.5
        mapTypeBtn.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        // 現在地ボタンのデザイン更新
        locationBtn.layer.shadowColor = UIColor.black.cgColor
        locationBtn.layer.shadowRadius = 2
        locationBtn.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        locationBtn.layer.shadowOpacity = 0.5
        locationBtn.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    
    // ピンをセットする
    private func setPinToMap() {
        for rock in rockList {
            // 岩ピン生成(Mock)
            let pinRock = MKPointAnnotation()
            pinRock.title = rock.name
            pinRock.coordinate = CLLocationCoordinate2D(latitude: rock.latitude, longitude: rock.longitude)
            
            mapView.addAnnotation(pinRock)
        }
    }
    
    // SearchTableViewのCellタップ時に飛ばれる
    @objc func searchCellTapped(notification: NSNotification?) {
        if isSearchArea {
            // 地名検索
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1) // 0.1が距離の倍率
            let coordinate = CLLocationCoordinate2D(latitude: searchlatitude, longitude: searchLongitude)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            mapView.region = region
        } else {
            // 岩・課題検索
            for rock in rockList {
                if (rock.name == searchName) {
                    // 岩名検索時
                    selectRockAnnotation(rockName: rock.name)
                    break
                }
                for project in rock.projects {
                    if (project.name == searchName) {
                        // 課題名検索時
                        selectRockAnnotation(rockName: rock.name)
                        break
                    }
                }
            }
        }
    }
    
    // 指定された岩名よりピンを選択し移動する
    private func selectRockAnnotation(rockName: String) {
        for annotation in mapView.annotations {
            if annotation.title == rockName {
                // ピンを指定
                mapView.selectAnnotation(annotation, animated: true)
                // ピンに移動
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1) // 0.1が距離の倍率
                let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
                mapView.region = region
            }
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    // 位置情報の許諾
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        // 許可されてない場合
        case .notDetermined:
            // 許可を求める
            manager.requestWhenInUseAuthorization()
        // 拒否されてる場合
        case .restricted, .denied:
            // 何もしない
            break
        // 許可されている場合
        case .authorizedAlways, .authorizedWhenInUse:
            // 現在地の取得を開始
            manager.startUpdatingLocation()
            break
        default:
            break
        }
    }
    
    // 位置情報の更新
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 初回のみ現在地に標準を合わせる
        if onceNowLocationFlag {
            if let coordinate = locations.last?.coordinate {
                // 現在地に移動
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1) // 0.01が距離の倍率
                let region = MKCoordinateRegion(center: coordinate, span: span)
                mapView.region = region
                
                onceNowLocationFlag = false
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
    // ピン押下時
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            
            // ユーザータップ時は何もしない
            if annotation is MKUserLocation {
                return
            }
            
            let mapDetailVC = MapDetailViewController.fromStoryboard()
            var isRockFlag = false
            for rock in rockList {
                let coordinate = annotation.coordinate
                if coordinate.latitude == rock.latitude && coordinate.longitude == rock.longitude {
                    mapDetailVC.rock = rock
                    isRockFlag = true
                    break
                }
            }
            
            // 岩の座標が一致しない場合(ピンがクラスター状態)
            if !isRockFlag {
                return
            }
            
            fpc.show()
            fpc.isRemovalInteractionEnabled = true
            let appearance = SurfaceAppearance()
            appearance.cornerRadius = 9.0
            fpc.surfaceView.appearance = appearance
            fpc.set(contentViewController: mapDetailVC)
            fpc.addPanel(toParent: self)
            fpc.track(scrollView: mapDetailVC.mapDetailTableView)
        }
    }
    
    // マップ表示時
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 現在地の場合はカスタムしない
        if annotation is MKUserLocation{
            return nil
        }
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier, for: annotation)
        
        guard let markerAnnotationView = annotationView as? MKMarkerAnnotationView else {
            return annotationView
        }

        markerAnnotationView.clusteringIdentifier = "cluster"
        markerAnnotationView.annotation = annotation

        return markerAnnotationView
    }
}

extension MapViewController: UISearchBarDelegate {
    // testFieldのタップを検知
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        fpc.hide()
        
        self.view.endEditing(true)
        let storyboard = UIStoryboard(name: "Search",bundle: nil)
        guard let viewController =  storyboard.instantiateInitialViewController() as? SearchTableViewController else { return }
        
        var rockNames: Array<String> = []
        var projectNames: Array<String> = []
        for rock in rockList {
            if rock.name != "無題" {
                rockNames.append(rock.name)
            }
            for project in rock.projects {
                if project.name != "無題" {
                    projectNames.append(project.name)
                }
            }
        }
        viewController.rockNames = rockNames
        viewController.projectNames = projectNames
        present(viewController, animated: true)
    }
}

extension MapViewController: FloatingPanelControllerDelegate {
    // カスタム半モーダル
    func floatingPanel(_ fpc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return LandscapePanelLayout()
    }
}

class LandscapePanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 130.0, edge: .bottom, referenceGuide: .safeArea),
        ]
    }
}
