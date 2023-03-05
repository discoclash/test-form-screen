//
//  PersonModel.swift
//  TestScreen
//
//  Created by G on 09.02.2023.
//

import UIKit

struct PersonModel {
    var image: UIImage?
    var surname: String?
    var name: String?
    var lastName: String?
    var age: Int?
    
    var isCompeted: Bool {
        if name != nil && surname != nil && age != nil &&  lastName != nil  {
            return true
        }
        return false
    }
}

var mainViewControllerData = ["Фамилия", "Имя", "Отчество", "Возраст"]
