//
//  MapDetailViewController.swift
//  Climbing-Map
//
//  Created by riku on 2021/04/25.
//

import UIKit

class MapDetailViewController: UIViewController {
    
    @IBOutlet weak var mapDetailTableView: UITableView!
    
    var rock: RockModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapDetailTableView.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageTableViewCell")
        mapDetailTableView.register(UINib(nibName: "ProjectTableViewCell", bundle: nil), forCellReuseIdentifier: "ProjectTableViewCell")
        
        self.setupRocks()
    }
    
    func setupRocks() {
        rock = RockModel(name: "日陰岩",
                         projects: [
                            ProjectModel(name: "彩雨", grade: "初段"),
                            ProjectModel(name: "嶺の夕", grade: "1級"),
                            ProjectModel(name: "NewSoul", grade: "2級"),
                            ProjectModel(name: "日陰者", grade: "4級"),
                            ProjectModel(name: "彩雨", grade: "初段"),
                            ProjectModel(name: "嶺の夕", grade: "1級"),
                            ProjectModel(name: "NewSoul", grade: "2級"),
                            ProjectModel(name: "日陰者", grade: "4級")
                         ])
    }
}

extension MapDetailViewController: UITableViewDelegate, UITableViewDataSource {

    static func fromStoryboard(_ storyboard: UIStoryboard = UIStoryboard(name: "MapDetail", bundle: nil)) -> MapDetailViewController {
        let controller = storyboard.instantiateViewController(withIdentifier: "MapDetailViewController") as! MapDetailViewController
        return controller
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rock.projects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell") as! ImageTableViewCell
            cell.setRock(name: rock.name)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectTableViewCell") as! ProjectTableViewCell
            cell.movieDelegate = self
            cell.setProject(project: rock.projects[indexPath.row])
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
    func tappedYoutube(name: String) {
        let webview = WKWebviewController()
        webview.name = name
        webview.isYoutube = true
        present(webview, animated: true, completion: nil)
    }
    
    func tappedInstagram(name: String) {
        let webview = WKWebviewController()
        webview.name = name
        webview.isYoutube = false
        present(webview, animated: true, completion: nil)
    }
}
