//
//  ImageTableViewCell.swift
//  Climbing-Map
//
//  Created by riku on 2021/04/26.
//

import UIKit
//import FirebaseStorage

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rockImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setRock(name: String) {
        self.name.text = name
        
//        let storage = Storage.storage()
//        let reference = storage.reference(forURL: "gs://sotoiwa-map.appspot.com/rocks/\(name)/\(name).jpg")
//        reference.downloadURL { url, error in
//            if let url = url {
//                do {
//                    let data = try Data(contentsOf: url)
//                    self.rockImageView.image = UIImage(data: data)
//                } catch let error {
//                    print("Error : \(error.localizedDescription)")
//                }
//            } else {
//                print(error ?? "")
//            }
//        }
        
//        let urlString = "https://storage.cloud.google.com/sotoiwa-map.appspot.com/rocks/\(name)/\(name).jpg?authuser=1"
//        let urlString = "https://storage.cloud.google.com/sotoiwa-map.appspot.com/rocks/test/test.jpg?authuser=1"
//        let urlString = "https://storage.cloud.google.com/sotoiwa-map.appspot.com/rocks/test/test.jpg"
////        let encodeUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
//        if let url = URL(string: urlString) {
//            do {
//               let data = try Data(contentsOf: url)
//               self.rockImageView.image = UIImage(data: data)
//             }catch let err {
//               print("Error : \(err.localizedDescription)")
//             }
//        }
    }
}
