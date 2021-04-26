//
//  RockModel.swift
//  Climbing-Map
//
//  Created by riku on 2021/04/26.
//

import Foundation

class RockModel : NSObject {
    var name: String
    var grade: String
    var youtubeURL: String
    var instagramURL: String

    init(name: String, grade: String, youtubeURL: String, instagramURL: String){
        self.name = name as String
        self.grade = grade as String
        self.youtubeURL = youtubeURL as String
        self.instagramURL = instagramURL as String
    }
}
