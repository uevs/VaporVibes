import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "Hello.\n\nUse a GET request on /vibes to read a random good vibe from another student. Use a POST request to /vibes send your good vibe, if you save the ID you can edit or delete it later with DELETE and PUT requests.\n\nGood vibes only."
    }


    try app.register(collection: MessageController())
}
