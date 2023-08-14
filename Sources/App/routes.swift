import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    app.post("api", "books") { req -> EventLoopFuture<Book> in
        let book = try req.content.decode(Book.self)
        return book.save(on: req.db).map({book})
    }
    
    app.get("api", "books") { req -> EventLoopFuture<[Book]> in
        Book.query(on: req.db).all()
    }
    
    // MARK: - get single book using id
    
    app.get("api", "books", ":bookID") { req -> EventLoopFuture<Book> in
        Book.find(req.parameters.get("bookID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    // MARK - Update
    
    app.put("api", "books", ":bookID") { req -> EventLoopFuture<Book> in
        let updated = try req.content.decode(Book.self)
        
        return Book.find(req.parameters.get("bookID"), on: req.db)
            .unwrap(or: Abort(.notFound)).flatMap{ book in
                book.title = updated.title
                book.author = updated.author
                book.year = updated.year
                
                return book.save(on: req.db).map({book})
            }
        
    }
    
    // MARK: - delete
    
    app.delete("api", "books", ":bookID") { req -> EventLoopFuture<HTTPStatus> in
       return Book.find(req.parameters.get("bookID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { book in
                book.delete(on: req.db)
                    .transform(to: .noContent)
            }
    }
}


// f28d19c2-077a-49b8-9af4-f16a11e07055
