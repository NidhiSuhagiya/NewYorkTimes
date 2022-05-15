//
//  NewsWebServices.swift
//  NewYorkTimes
//
//  Created by Nidhi Suhagiya on 12/05/22.
//

import Foundation

class NewsWebServices {
    
    /// Fetch top news stories from server
    /// - Parameters:
    ///   - selectedSection: section name to fetch news of that section
    ///   - completion: closure to return response
    func getTopStories(selectedSection: String, completion: @escaping ([NewsResults]?) -> ()) {
        
        let apiUrl = ApiInfo.baseUrl + selectedSection + ApiInfo.apiExtension
        
        if var urlComponents = URLComponents(string: apiUrl) {
            urlComponents.query = "api-key=" + ApiInfo.newYorkTimesApiKey
            
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

