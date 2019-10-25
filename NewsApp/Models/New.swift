//
//  New.swift
//  getYourNews
//
//  Created by Cosme Fulanito on 14/10/2019.
//  Copyright © 2019 Cosme Fulanito. All rights reserved.
//

import Foundation

class New {
    var author: String
    var title: String
    var description: String
    var url: String
    var urlToImage: String
    var publishedAt: Date
    var content: String
    
    init() {
        self.author = ""
        self.title = ""
        self.description = ""
        self.url = ""
        self.urlToImage = ""
        self.publishedAt = Date()
        self.content = ""
    }
    
    static func from(_ author: String, title: String, description: String, url: String, urlToImage: String, publishedAt: String, content: String) -> New {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let new = New()
        
        new.author = author
        new.title = title
        new.description = description
        new.url = url
        new.urlToImage = urlToImage
        new.publishedAt = dateFormatter.date(from: publishedAt) ?? Date()
        new.content = content
        
        return new
    }
}
