//
//  MapDetailViewController.swift
//  Climbing-Map
//
//  Created by riku on 2021/04/25.
//

import UIKit

class MapDetailViewController: UIViewController {
    
    @IBOutlet weak var mapDetailTableView: UITableView!
    
    enum Cell: Int, CaseIterable {
        case imageCustomViewCell
        case rockCustomViewCell
        case projectCustomViewCell

        var cellIdentifier: String {
            switch self {
            case .imageCustomViewCell: return "ImageTableViewCell"
            case .rockCustomViewCell: return "RockTableViewCell"
            case .projectCustomViewCell: return "ProjectTableViewCell"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapDetailTableView.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageTableViewCell")
        mapDetailTableView.register(UINib(nibName: "RockTableViewCell", bundle: nil), forCellReuseIdentifier: "RockTableViewCell")
        mapDetailTableView.register(UINib(nibName: "ProjectTableViewCell", bundle: nil), forCellReuseIdentifier: "ProjectTableViewCell")
    }
}

extension MapDetailViewController: UITableViewDelegate, UITableViewDataSource {

    static func fromStoryboard(_ storyboard: UIStoryboard = UIStoryboard(name: "MapDetail", bundle: nil)) -> MapDetailViewController {
        let controller = storyboard.instantiateViewController(withIdentifier: "MapDetailViewController") as! MapDetailViewController
        return controller
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Cell.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = Cell(rawValue: indexPath.row)!
        switch cellType {
        case .imageCustomViewCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.cellIdentifier) as! ImageTableViewCell
            return cell
        case .rockCustomViewCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.cellIdentifier) as! RockTableViewCell
            return cell
        case .projectCustomViewCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.cellIdentifier) as! ProjectTableViewCell
            return cell
        }
    }
}
