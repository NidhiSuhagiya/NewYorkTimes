//
//  NewsWebServices.swift
//  NewYorkTimes
//
//  Created by Nidhi Suhagiya on 12/05/22.
//

import Foundation

class NewsWebServices {
    
    func getTopStories(selectedSection: String, completion: @escaping ([NewsResults]?) -> ()) {
        
        let apiUrl = "https://api.nytimes.com/svc/topstories/v2/" + selectedSection + ".json"
        
        if var urlComponents = URLComponents(string: apiUrl) {
            urlComponents.query = "api-key=nBAln1lClbtS9K5KPSHcFwzeGnKZOh5I"
            
            URLSession.shared.dataTask(with: urlComponents.url!) { data, response, error in
                guard let responseData = data else {
                    print("Error to fetch New York Top Stories: \(error?.localizedDescription)")
                    completion(nil)
                    return
                }
                let articleList = try? JSONDecoder().decode(NewsResponseModel.self, from: responseData)
                completion(articleList?.results ?? [])
            }.resume()
        }
    }
}

