//
//  ProjectTableViewCell.swift
//  Climbing-Map
//
//  Created by riku on 2021/04/26.
//

import UIKit

protocol MovieTappedDelegate: class {
    func tappedSOTOIWA(name: String)
    func tappedInstagram(name: String)
}

class ProjectTableViewCell: UITableViewCell {
    
    weak var movieDelegate: MovieTappedDelegate?

    @IBOutlet weak var grade: UILabel!
    @IBOutlet weak var name: UILabel!
    
    @IBAction func tappedSOTOIWA(_ sender: CustomButton) {
        movieDelegate?.tappedSOTOIWA(name: self.name.text!)
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
    
    func setProject(project: RockModel) {
        self.name.text = project.name as String
        self.grade.text = project.grade as String
    }
}
