//
//  Constant.swift
//  NewYorkTimes
//
//  Created by Nidhi Suhagiya on 12/05/22.
//

import UIKit

let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)

enum ImageFormat {
    case largeImage
    case thumbnail
    
    var description: String {
        switch self {
        case .largeImage:
            return "Super Jumbo"
        case .thumbnail:
            return "Large Thumbnail"
        }
    }
}
