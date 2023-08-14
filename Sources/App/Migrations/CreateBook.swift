//
//  CreateBook.swift
//  
//
//  Created by Артём Тюрморезов on 14.08.2023.
//

import Fluent


struct CreateBook: Migration {
    // delete from
    func revert(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("books").delete()
    }
    
    // adding
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("books")
            .id()
            .field("title", .string, .required)
            .field("author", .string, .required)
            .field("year", .int, .required)
            .create()
    }
}
