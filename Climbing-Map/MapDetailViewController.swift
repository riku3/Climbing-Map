//
//  MapDetailViewController.swift
//  Climbing-Map
//
//  Created by riku on 2021/04/25.
//

import UIKit
import FirebaseStorage
import AlamofireImage

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

            // 岩名なし
            if rock.name == "無題" {
                // public化したStorageより画像取得(AlamofireImageより自動キャッシュ)
                let rockNameEncode = rock.name.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
                let path = rockNameEncode + String(rock.id)
                let urlString = "https://firebasestorage.googleapis.com/v0/b/sotoiwa-map.appspot.com/o/rocks%2F\(path)%2F\(path).jpg?alt=media"
                if let url = URL(string: urlString) {
                    cell.rockImageView.af.setImage(withURL: url)
                }
            // 岩名あり
            } else {
                // public化したStorageより画像取得(AlamofireImageより自動キャッシュ)
                let encodeRockName = rock.name.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
                let urlString = "https://firebasestorage.googleapis.com/v0/b/sotoiwa-map.appspot.com/o/rocks%2F\(encodeRockName)%2F\(encodeRockName).jpg?alt=media"
                if let url = URL(string: urlString) {
                    cell.rockImageView.af.setImage(withURL: url)
                    cell.setRock(name: self.rock.name)
                }
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectTableViewCell") as! ProjectTableViewCell
            cell.movieDelegate = self
            cell.setProject(project: rock.projects[indexPath.row - 1])
            
            // 岩・課題が無題の場合はYoutubeボタンを非活性にする
            if (rock.name == "無題" && rock.projects[indexPath.row - 1].name == "無題") {
                cell.disabledYoutubeBtn()
            }
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
    func tappedYoutube(projectName: String) {
        let webview = WKWebviewController()
        webview.projectName = projectName
        webview.rockName = rock.name
        present(webview, animated: true, completion: nil)
    }
}
