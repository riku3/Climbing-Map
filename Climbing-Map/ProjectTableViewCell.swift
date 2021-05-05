//
//  ProjectTableViewCell.swift
//  Climbing-Map
//
//  Created by riku on 2021/04/26.
//

import UIKit

protocol MovieTappedDelegate: class {
    func tappedYoutube(projectName: String)
}

class ProjectTableViewCell: UITableViewCell {
    
    weak var movieDelegate: MovieTappedDelegate?

    @IBOutlet weak var grade: UILabel!
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var youtubeBtn: CustomButton!
    
    @IBAction func tappedYoutube(_ sender: CustomButton) {
        movieDelegate?.tappedYoutube(projectName: self.projectName.text!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setProject(project: Project) {
        self.projectName.text = project.name as String
        self.grade.text = project.grade as String
    }
    
    func disabledYoutubeBtn() {
        youtubeBtn.isEnabled = false
        youtubeBtn.backgroundColor = UIColor.lightGray
        youtubeBtn.setTitle("岩・課題の検索ができません", for: .normal)
    }
}
