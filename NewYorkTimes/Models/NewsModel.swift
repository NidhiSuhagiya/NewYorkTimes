//
//  NewsModel.swift
//  NewYorkTimes
//
//  Created by Nidhi Suhagiya on 12/05/22.
//

import Foundation

struct NewsResponseModel : Codable {
    
    let status : String?
    let section : String?
    let num_results : Int?
    let results : [NewsResults]?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case section = "section"
        case num_results = "num_results"
        case results = "results"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        section = try values.decodeIfPresent(String.self, forKey: .section)
        num_results = try values.decodeIfPresent(Int.self, forKey: .num_results)
        results = try values.decodeIfPresent([NewsResults].self, forKey: .results)
    }
    
}

struct NewsResults : Codable {
    let section: String?
    let title : String?
    let abstract : String?
    let url : String?
    let authorName : String?
    let published_date : String?
    var formattedPublishedDate: String? { return convertPublishDateToStr(dateStr: published_date) }
    let multimedia : [NewsMultimedia]?
    
    enum CodingKeys: String, CodingKey {
        case section = "section"
        case title = "title"
        case abstract = "abstract"
        case url = "url"
        case authorName = "byline"
        case published_date = "published_date"
        case multimedia = "multimedia"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        section = try values.decodeIfPresent(String.self, forKey: .section)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        abstract = try values.decodeIfPresent(String.self, forKey: .abstract)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        authorName = try values.decodeIfPresent(String.self, forKey: .authorName)
        published_date = try values.decodeIfPresent(String.self, forKey: .published_date)
        multimedia = try values.decodeIfPresent([NewsMultimedia].self, forKey: .multimedia)
    }
    
    //    Convert received date string to the custom string (10 May 2022)
    private func convertPublishDateToStr(dateStr: String?) -> String {
        //        2022-05-09T04:39:33-04:00
        guard let currentDate = dateStr else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let convertedDate = dateFormatter.date(from: currentDate)
        dateFormatter.dateFormat = "dd MMM YYYY"
        let newDateStr = dateFormatter.string(from: convertedDate!)
        return newDateStr
    }
}

struct NewsMultimedia : Codable {
    let url : String?
    let format : String?
    
    enum CodingKeys: String, CodingKey {
        
        case url = "url"
        case format = "format"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        format = try values.decodeIfPresent(String.self, forKey: .format)
    }
    
}

