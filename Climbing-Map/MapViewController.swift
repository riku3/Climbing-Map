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
    var locationManager: CLLocationManager!
    
    var onceNowLocationFlag = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ロケーションマネージャーのセットアップ
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager!.requestWhenInUseAuthorization()
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
                // 現在地を拡大して表示する
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) // 0.01が距離の倍率
                let region = MKCoordinateRegion(center: coordinate, span: span)
                mapView.region = region
                
                onceNowLocationFlag = false
            }
        }
    }
}
