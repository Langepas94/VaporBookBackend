//
//  Book.swift
//  
//
//  Created by Артём Тюрморезов on 14.08.2023.
//

import Foundation
import Vapor
import Fluent

final class Book: Model {
    
    static var schema: String = "books"
    
    @ID
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "author")
    var author: String
    
    @Field(key: "year")
    var year: Int
    
    init(){}
    
    init(id: UUID?, title: String, author: String, year: Int) {
        self.id = id
        self.title = title
        self.author = author
        self.year = year
    }
}

extension Book: Content {}
