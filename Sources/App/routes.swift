import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    app.post("api", "books") { req -> EventLoopFuture<Book> in
        let book = try req.content.decode(Book.self)
        return book.save(on: req.db).map({book})
    }
    
    app.get("api", "books") { req -> EventLoopFuture<[Book]> in
        Book.query(on: req.db).all()
    }
}
