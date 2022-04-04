import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "Hello.\n\nUse a GET request to read a random good vibe from another student. Use a POST request to send your good vibe.\n\nGood vibes only."
    }


    try app.register(collection: MessageController())
}
