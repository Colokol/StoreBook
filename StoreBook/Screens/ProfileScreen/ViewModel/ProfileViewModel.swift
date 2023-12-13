//
//  ProfileViewModel.swift
//  StoreBook
//
//  Created by Дмитрий on 12.12.2023.
//

import UIKit

class ProfileViewModel {
    
    var profileModel: ProfileModel

    init(profileModel: ProfileModel) {
        self.profileModel = profileModel
    }
//    var displayName: NSAttributedString {
//            let labelText = NSMutableAttributedString()
//
//            let firstAttributes: [NSAttributedString.Key: Any] = [
//                .font: UIFont(name: "OpenSans-Regular", size: 14) as Any,
//                .foregroundColor: UIColor.black
//            ]
//            let firstString = NSAttributedString(string: "Name:                      ", attributes: firstAttributes)
//            labelText.append(firstString)
//
//            let secondAttributes: [NSAttributedString.Key: Any] = [
//                .font: UIFont(name: "OpenSans-SemiBold", size: 16) as Any,
//                .foregroundColor: UIColor.black,
//            ]
//            let secondString = NSAttributedString(string: profileModel.name, attributes: secondAttributes)
//            labelText.append(secondString)
//            
//            return labelText
//        }
    
}
