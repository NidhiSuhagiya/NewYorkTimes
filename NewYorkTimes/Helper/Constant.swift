//
//  Constant.swift
//  NewYorkTimes
//
//  Created by Nidhi Suhagiya on 12/05/22.
//

import UIKit

let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)

struct ApiInfo {
    static let baseUrl = "https://api.nytimes.com/svc/topstories/v2/"
    static let newYorkTimesApiKey = "nBAln1lClbtS9K5KPSHcFwzeGnKZOh5I"
    static let apiExtension = ".json"
}

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
