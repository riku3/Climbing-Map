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
    var name: String
    var longitude: Double
    var latitude: Double
    var projects: [Project]
}
struct Project {
    var name: String
    var grade: String
}

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var locationManager: CLLocationManager!
    var onceNowLocationFlag = true
    var fpc = FloatingPanelController()
    var rockList: [Rock] = []
    var searchName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = Firestore.firestore()
        db.collection("rocks").getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let projectDicList: [[String : Any]] = document.get("projects") as! [[String : Any]]
                    var projects: [Project] = []
                    for projectDic in projectDicList {
                        let project = Project(
                                        name: projectDic["name"] as! String,
                                        grade: projectDic["grade"] as! String)
                        projects.append(project)
                    }
                    let rock = Rock(
                        name: document.get("name") as! String,
                        longitude: document.get("longitude") as! Double,
                        latitude: document.get("latitude") as! Double,
                        projects: projects)
                    self.rockList.append(rock)
                    setPinToMap()
                }
            }
        }
        
        // セットアップ
        setUpLocationManager()
        setUpLocationBtn()
        
        // delegate
        locationManager.delegate = self
        mapView.delegate = self
        fpc.delegate = self
        searchBar.delegate = self
        
        // TODO: 方角表示(追従されるため実装方法を工夫する必要あり)
//        mapView.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: true)
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
    
    // ロケーションマネージャーのセットアップ
    private func setUpLocationManager() {
        // ロケーションマネージャーのセットアップ
        locationManager = CLLocationManager()
        locationManager!.requestWhenInUseAuthorization()
    }
    // ロケーションボタンを設定する
    private func setUpLocationBtn() {
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
            // サブタイトル
    //        rock.subtitle = "初段×1,1級×1,2級×1,4級×1"
            pinRock.coordinate = CLLocationCoordinate2D(latitude: rock.latitude, longitude: rock.longitude)
            mapView.addAnnotation(pinRock)
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
            let mapDetailVC = MapDetailViewController.fromStoryboard()
            for rock in rockList {
                if annotation.title == rock.name {
                    mapDetailVC.rock = rock
                    break
                }
            }
            fpc.show()
            let appearance = SurfaceAppearance()
            appearance.cornerRadius = 9.0
            fpc.surfaceView.appearance = appearance
            // マージンの変更
//            fpc.surfaceView.containerMargins = .init(top: 0, left: 10.0, bottom: 0, right: 10.0)
            fpc.set(contentViewController: mapDetailVC)
            fpc.addPanel(toParent: self)
            fpc.track(scrollView: mapDetailVC.mapDetailTableView)
        }
    }
}

extension MapViewController: UISearchBarDelegate {
    // testFieldのタップを検知
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        let storyboard = UIStoryboard(name: "Search",bundle: nil)
        guard let viewController =  storyboard.instantiateInitialViewController() as? SearchTableViewController else { return }
        
        var rockNames: Array<String> = []
        var projectNames: Array<String> = []
        for rock in rockList {
            rockNames.append(rock.name)
            for project in rock.projects {
                projectNames.append(project.name)
            }
        }
        viewController.rockNames = rockNames
        viewController.projectNames = projectNames
        viewController.presentationController?.delegate = self
        present(viewController, animated: true)
    }
}

extension MapViewController: UIAdaptivePresentationControllerDelegate {
    // 遷移先のdismissを検知
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
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
    // 横幅のカスタム
//    func prepareLayout(surfaceView: UIView, in view: UIView) -> [NSLayoutConstraint] {
//        return [
//            surfaceView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8.0),
//            surfaceView.widthAnchor.constraint(equalToConstant: 291),
//        ]
//    }
}
