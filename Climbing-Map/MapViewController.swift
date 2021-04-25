//
//  MapViewController.swift
//  Climbing-Map
//
//  Created by riku on 2021/04/25.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationBtn: UIButton!
    var locationManager: CLLocationManager!
    var onceNowLocationFlag = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 現在地ボタンのデザイン更新
        locationBtn.layer.shadowColor = UIColor.black.cgColor
        locationBtn.layer.shadowRadius = 2
        locationBtn.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        locationBtn.layer.shadowOpacity = 0.5
        locationBtn.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        // ロケーションマネージャーのセットアップ
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager!.requestWhenInUseAuthorization()
        
        // 岩ピン生成(Mock)
        let rock = MKPointAnnotation()
        rock.title = "嶺の夕"
        rock.subtitle = "初段×1,1級×1,2級×1,4級×1"
        rock.coordinate = CLLocationCoordinate2D(latitude: 35.801301, longitude: 139.945875)
        mapView.addAnnotation(rock)
        
        mapView.delegate = self
    }
    
    @IBAction func tappedLocationBtn(_ sender: UIButton) {
        // 現在地に移動
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1) // 0.01が距離の倍率
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: span)
        mapView.region = region
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
        if let annotation = view.annotation{
            print(annotation.title!!)
        }
    }
}
