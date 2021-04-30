//
//  MapDetailViewController.swift
//  Climbing-Map
//
//  Created by riku on 2021/04/25.
//

import UIKit
import FirebaseStorage

class MapDetailViewController: UIViewController {
    
    @IBOutlet weak var mapDetailTableView: UITableView!
    
    var rock: Rock!
    var rockImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapDetailTableView.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageTableViewCell")
        mapDetailTableView.register(UINib(nibName: "ProjectTableViewCell", bundle: nil), forCellReuseIdentifier: "ProjectTableViewCell")
    }
}

extension MapDetailViewController: UITableViewDelegate, UITableViewDataSource {

    static func fromStoryboard(_ storyboard: UIStoryboard = UIStoryboard(name: "MapDetail", bundle: nil)) -> MapDetailViewController {
        let controller = storyboard.instantiateViewController(withIdentifier: "MapDetailViewController") as! MapDetailViewController
        return controller
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + (rock?.projects.count ?? 0)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell") as! ImageTableViewCell
            let storage = Storage.storage()
            let reference = storage.reference(forURL: "gs://sotoiwa-map.appspot.com/rocks/\(rock.name)/\(rock.name).jpg")
            reference.downloadURL { url, error in
                if let url = url {
                    do {
                        let data = try Data(contentsOf: url)
                        cell.rockImageView.image = UIImage(data: data)
                        cell.setRock(name: self.rock.name)
                    } catch let error {
                        print("Error : \(error.localizedDescription)")
                    }
                } else {
                    print(error ?? "")
                }
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectTableViewCell") as! ProjectTableViewCell
            cell.movieDelegate = self
            cell.setProject(project: rock.projects[indexPath.row - 1])
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
        present(webview, animated: true, completion: nil)
    }
}
