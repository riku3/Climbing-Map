//
//  ContentViewController.swift
//  Climbing-Map
//
//  Created by riku on 2021/04/26.
//

import UIKit

class ContentViewController: UIViewController {

   lazy var tableView: UITableView = {
     let tableView = UITableView(frame: .zero)
     tableView.backgroundColor = .white
     tableView.dataSource = self
     tableView.contentInsetAdjustmentBehavior = .always
     return tableView
   }()
   
   override func viewDidLoad() {
       super.viewDidLoad()
       view.backgroundColor = .green
       view.addSubview(tableView)

       tableView.translatesAutoresizingMaskIntoConstraints = false
       NSLayoutConstraint.activate([
         tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         tableView.topAnchor.constraint(equalTo: view.topAnchor),
         tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
       ])
   }
}

extension ContentViewController: UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 100
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = UITableViewCell()
       cell.textLabel?.text = "\(indexPath.row)行目"
       return cell
   }
}
