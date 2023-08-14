//
//  BooksController.swift
//  
//
//  Created by Артём Тюрморезов on 14.08.2023.
//

import Vapor
import Fluent

struct BooksController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let booksRoutes = routes.grouped("api", "books")
        
        booksRoutes.get(use: getAllHandler)
        booksRoutes.get(":bookID", use: getBookHandler)
        booksRoutes.post(use: createBookHandler)
        booksRoutes.put(":bookID", use: updateHandler)
        booksRoutes.delete(":bookID", use: deleteHandler)
    }
    
    func getAllHandler(_ request: Request) -> EventLoopFuture<[Book]> {
        Book.query(on: request.db).all()
    }
    
    func getBookHandler(_ request: Request) -> EventLoopFuture<Book> {
        Book.find(request.parameters.get("bookID"), on: request.db)
            .unwrap(or: Abort(.notFound))
    }
    
    func createBookHandler( _ request: Request) throws -> EventLoopFuture<Book> {
        let book = try request.content.decode(Book.self)
        
        return book.save(on: request.db).map { book }
    }
    
    func updateHandler( _ request: Request) throws -> EventLoopFuture<Book> {
        let updated = try request.content.decode(Book.self)
        
        return Book.find(request.parameters.get("bookID"), on: request.db)
            .unwrap(or: Abort(.notFound)).flatMap{ book in
                book.title = updated.title
                book.author = updated.author
                book.year = updated.year
                
                return book.save(on: request.db).map({book})
            }
    }
    
    func deleteHandler(_ request: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Book.find(request.parameters.get("bookID"), on: request.db)
             .unwrap(or: Abort(.notFound))
             .flatMap { book in
                 book.delete(on: request.db)
                     .transform(to: .noContent)
             }
    }
}
