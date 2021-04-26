//
//  ProjectTableViewCell.swift
//  Climbing-Map
//
//  Created by riku on 2021/04/26.
//

import UIKit

protocol MovieTappedDelegate: class {
    func tappedYoutube(name: String)
    func tappedInstagram(name: String)
}

class ProjectTableViewCell: UITableViewCell {
    
    weak var movieDelegate: MovieTappedDelegate?

    @IBOutlet weak var grade: UILabel!
    @IBOutlet weak var name: UILabel!
    
    @IBAction func tappedYoutube(_ sender: CustomButton) {
        movieDelegate?.tappedYoutube(name: self.name.text!)
    }
    @IBAction func tappedInstagram(_ sender: CustomButton) {
        movieDelegate?.tappedInstagram(name: self.name.text!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setProject(project: ProjectModel) {
        self.name.text = project.name as String
        self.grade.text = project.grade as String
    }
}
