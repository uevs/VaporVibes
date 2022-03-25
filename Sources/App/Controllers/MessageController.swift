import Fluent
import Vapor

struct MessageController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let messages = routes.grouped("messages")
        messages.get(use: index)
        messages.post(use: create)
        messages.group(":messageID") { message in
            message.delete(use: delete)
        }
    }

    func index(req: Request) async throws -> [Message] {
        try await Message.query(on: req.db).all()
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
}
