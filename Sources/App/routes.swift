import Fluent
import Vapor

func routes(_ app: Application) throws {
    let bookController = BooksController()
    try app.register(collection: bookController)
}


// f28d19c2-077a-49b8-9af4-f16a11e07055
