//
//  MapDetailViewController.swift
//  Climbing-Map
//
//  Created by riku on 2021/04/25.
//

import UIKit

class MapDetailViewController: UIViewController {
    
    @IBOutlet weak var mapDetailTableView: UITableView!
    
    var rocks:[RockModel] = [RockModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapDetailTableView.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageTableViewCell")
        mapDetailTableView.register(UINib(nibName: "ProjectTableViewCell", bundle: nil), forCellReuseIdentifier: "ProjectTableViewCell")
        
        self.setupRocks()
    }
    
    func setupRocks() {
        rocks = [
            RockModel(name: "彩雨", grade: "初段", sotoiwaURL: "", instagramURL: ""),
            RockModel(name: "嶺の夕", grade: "1級", sotoiwaURL: "", instagramURL: ""),
            RockModel(name: "NewSoul", grade: "2級", sotoiwaURL: "", instagramURL: ""),
            RockModel(name: "日陰者", grade: "4級", sotoiwaURL: "", instagramURL: ""),
            RockModel(name: "彩雨", grade: "初段", sotoiwaURL: "", instagramURL: ""),
            RockModel(name: "嶺の夕", grade: "1級", sotoiwaURL: "", instagramURL: ""),
            RockModel(name: "NewSoul", grade: "2級", sotoiwaURL: "", instagramURL: ""),
            RockModel(name: "日陰者", grade: "4級", sotoiwaURL: "", instagramURL: "")]
    }
}

extension MapDetailViewController: UITableViewDelegate, UITableViewDataSource {

    static func fromStoryboard(_ storyboard: UIStoryboard = UIStoryboard(name: "MapDetail", bundle: nil)) -> MapDetailViewController {
        let controller = storyboard.instantiateViewController(withIdentifier: "MapDetailViewController") as! MapDetailViewController
        return controller
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rocks.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell") as! ImageTableViewCell
            cell.setRock(name: "日陰岩")
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectTableViewCell") as! ProjectTableViewCell
            cell.movieDelegate = self
            cell.setProject(project: rocks[indexPath.row - 1])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 170
        default:
            return 130
        }
    }
}

extension MapDetailViewController: MovieTappedDelegate {
    func tappedSOTOIWA(name: String) {
        dismiss(animated: true, completion: nil)
    }
    
    func tappedInstagram(name: String) {
        dismiss(animated: true, completion: nil)
    }
}
