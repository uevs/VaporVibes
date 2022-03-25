import Fluent
import Vapor

struct MessageController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let messages = routes.grouped("vibes")
        messages.get(use: index)
        messages.post(use: create)
        messages.group(":messageID") { message in
            message.delete(use: delete)
            message.get(use: retrieve)
            message.put(use: update)
        }
    }

    func index(req: Request) async throws -> String {
        guard let message = try await Message.query(on: req.db).all().randomElement() else {
            return "No good vibes yet :("
        }
        
        return "Your good vibe is \(message.message) from \(message.from)"


    }
    
    func retrieve(req: Request) async throws -> Message {
        guard let message = try await Message.find(req.parameters.get("messageID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return message
    }

    func create(req: Request) async throws -> Message {
        let message = try req.content.decode(Message.self)
        try await message.save(on: req.db)
        return message
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let message = try await Message.find(req.parameters.get("messageID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await message.delete(on: req.db)
        return .ok
    }
    
    func update(req: Request) async throws -> HTTPStatus {
        let newMessage = try req.content.decode(Message.self)

        guard let message = try await Message.find(req.parameters.get("messageID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        message.message = newMessage.message
        message.from = newMessage.from
        try await message.update(on: req.db)
        
        return .ok
    }
}
