//
//  NewsListViewModel.swift
//  NewYorkTimes
//
//  Created by Nidhi Suhagiya on 12/05/22.
//

import Foundation

class NewsListViewModel {
    
    var newsList = [NewsResults]()
    
    var numberOfRows: Int {
        return newsList.count
    }
    
    var isNewsListEmpty: Bool {
        return newsList.isEmpty
    }
    
    func newsAtIndex(_ index: Int) -> NewsResults {
        let news = newsList[index]
        return news
    }
}

extension NewsListViewModel {
    
    func clearNewsListToLoadNewSection() {
        self.newsList = []
    }
    
    func fetchNews(selectedSection: String, completion: @escaping ([NewsResults]?) -> ()) {
        NewsWebServices().getTopStories(selectedSection: selectedSection) { newsListArr in
            self.newsList = (newsListArr ?? []).self
            completion(self.newsList)
        }
    }
}


