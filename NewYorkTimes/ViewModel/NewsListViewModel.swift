//
//  NewsListViewModel.swift
//  NewYorkTimes
//
//  Created by Nidhi Suhagiya on 12/05/22.
//

import Foundation

struct NewsListViewModel {
    
    var newsList: [NewsResults]
    
    var numberOfRows: Int {
        return newsList.count
    }
    
    func newsAtIndex(_ index: Int) -> NewsResults {
        let news = newsList[index]
        return news
    }
}


