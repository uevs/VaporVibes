import Fluent
import Vapor

final class Message: Model, Content {
    static let schema = "messages"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "message")
    var message: String
    
    @Field(key: "from")
    var from: String

    init() { }

    init(id: UUID? = nil, message: String, from: String) {
        self.id = id
        self.message = message
        self.from = from
    }
}
