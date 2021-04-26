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

    init(name: String, grade: String){
        self.name = name as String
        self.grade = grade as String
    }
}
