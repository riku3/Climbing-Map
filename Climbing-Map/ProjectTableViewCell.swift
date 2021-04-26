//
//  ProjectTableViewCell.swift
//  Climbing-Map
//
//  Created by riku on 2021/04/26.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {

    @IBOutlet weak var grade: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setProject(project: RockModel) {
        self.name.text = project.name as String
        self.grade.text = project.grade as String
    }
}
