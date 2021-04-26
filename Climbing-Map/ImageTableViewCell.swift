//
//  ImageTableViewCell.swift
//  Climbing-Map
//
//  Created by riku on 2021/04/26.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setRock(name: String) {
        self.name.text = name
    }
}
