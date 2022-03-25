# VaporVibes

<p align="center">
    <a href="#" alt="Xcode Version">
        <img src="https://img.shields.io/static/v1?label=XCode%20Version&message=13&color=brightgreen&logo=xcode" alt="Xcode version 13"></a>
    <a href="#" alt="Swift Version">
        <img src="https://img.shields.io/static/v1?label=Swift%20Version&message=5.5&color=brightgreen&logo=swift" alt="Swift Version 5.5"></a>
    <a href="#" alt="Framework Vapor">
        <img src="https://img.shields.io/static/v1?label=Framework&message=Vapor&color=brightgreen&logo=Vapor"
            alt="Framework Vapor"></a>        
			
</p>

A simple vapor implementation to learn about Swift On Server.

## Description
This server allows Academy hackers to send good vibes to each other. You can send a new vibe with a POST request and you can get a random vibe with a GET request. If you save your vibe ID while you create a new one, you can also edit or delete it.

##Making sense of Vapor
Vapor is a powerful and easy to use framework, but it can be hard to approach since each thing require some prior knowledge of servers and networking. Many technical terms can be confusing for people new to coding and almost all of the information can become
I'm going to try to explain what Vapor is and how to approach it in as simple terms as possible, to help people without a technical background to approach Siwft on Server
Forgive all the inaccuracies, this aims to be undesrtandable!

## What's Vapor?
Vapor is a web framework. It allows you to setup software on a server and then communicate with it. When you use Swift, you are used to have it finalized into making apps, with Vapor you instead use it to make an app that runs on a server and communicates via web protocols.
When you click "run" on a Vapor project, the app starts

## Clearing things up

Working with Vapor assumes that you know or are willing to learn about: databases, servers, http requests, JSON, concurrency, REST API, Docker and many other fancy terms
A lot of fancy terms, but it's actually easier that what it looks like. I'm trying to explain it as simple as possile for non-technical people.

- A database is like a huge spreadsheet containg your data. Each "table" is a new spreadsheet with it's own columns containgn the fields (product name, quanity, SKU, etc), A row is "record" and is the actual data inside the database.
- A server is a computer that does a specific thing you connect to
- https requsts are a way to communicate with said serve. A GET request means "give me this information form the database", a POST request means "write this new information on the database"
- JSON is a format to encode information so that it travels in your requests without assles
- Concurrecny means that your app will wait for the server to respond, instead of crashing due to slow internet connections
- REST API are basically what you create that allows you to make machines communicate with each other.
- Docker is a thing that makes your life easier, just learn the basic commands for now.


## Understanding the Vapor template

A Vapor project is full of files and dependancies and it can be daunting, but it's actually made of three fundamental parts:
1) Controllers
2) Migrations
3) Models

Understanding how these works allow you to start to tinker with code really quickly.

Controllers are the code that allow you to manage your http requests (POST, GET, etc.). In here you can write swifty code about what should happen to each request.

Migrations is a confusing term that means "make changes to your database". Imagine that your DB is a huge spreadsheet, if you want to create a new sheet or define the headers of each column you are going to do it with migrations. Migrations are something you manually launch when you need them. For example to create a new table or update it.

Models are the data you are manipulating. That's it.

## Create something with Vapor

First you create your Model. You want to create a product for your amazing ecommerce? You create a model with all the related fields that are going to be stored ont he database
```swift
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
```



Then you create the Migration: you basically tell Vapor "hey, create a new table in the datavase for this new model I made".

```swift
struct CreateMessage: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("messages")
            .id()
            .field("message", .string, .required)
            .field("from", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("messages").delete()
    }
}
```

Now you have a model and a database that can store it, the controller is what allows you to interact with it. It all starts with this funciont, where you can decide what other functions will be called for each htttp request

```swift
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
```

fore example, if you use a get call, the "index" function will be called and this code will be exectued extracting a random good vibe from the database.

```swift
    func index(req: Request) async throws -> String {
        guard let message = try await Message.query(on: req.db).all().randomElement() else {
            return "No good vibes yet :("
        }
        return "Your good vibe is \(message.message) from \(message.from)"
    }
```

## That's it

This is a really simplistic overview of Vapor designed to get coders without a techincal background up to speed quickly, so that you can actually tinker with code and Vapor. If you want to get serious there's a lot of amazing documentation around te web and a great starting point is the [official documentation](https://docs.vapor.codes/4.0/ "official documentation").
