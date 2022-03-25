# VaporVibes

![logo](https://i.imgur.com/SjQqYIc.png)

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
This project allows Academy hackers to send good vibes to each other. You can send a new vibe with a POST request and you can get a random vibe with a GET request. If you save your vibe ID while you create a new one, you can also edit or delete it at a later time with PUT and DELETE requests.

## Making sense of Vapor
Vapor is a powerful and easy to use web framework, but it can be hard to approach for new coders because there are many new concepts that needs to be understood. Many technical terms can be confusing for people new to coding and it's easy to get lost or overwhelmed while learning fundamental concepts needed just to start and tinker with Vapor.

I'm going to try to explain what Vapor is and how to approach it in the simplest terms, to help people without a technical background to approach Swift on Server.
Technical people, forgive all the inaccuracies! This aims to be an easy to understand introudction, not a comprehensive expanation.

## What's Vapor?
Vapor is a web framework. It allows you to setup software on a server and then communicate with it. If you learned Swift to make apps this could be counter intiuitive at first, since you are building something completely different. With Vapor you cerate an app that runs on a server and you interact with it via web protocols, so with code instead of a graphical interface!

When you click "run" on a Vapor project the app starts without anything to show and it's working on the background. You can interact with it with your broswer or with tools like [Insomnia](https://insomnia.rest/), more on this later.

## Clearing things up

Working with Vapor assumes that you know or are willing to learn about: databases, servers, http requests, JSON, concurrency, REST API, Docker and many other fancy terms.
It's actually easier that what it looks like. I'm trying to explain them as simply as possile for non-technical people.

- A database is like a huge spreadsheet containg your data. Imagine each new "table" as new spreadsheet with it's own columns containing the fields you need (eg: product name, quanity, SKU, etc). A row is "record" and is the actual data inside the database.
- https requsts are a way to communicate with a server and your web app that runs on it. A GET request means "give me this information form the database", a POST request means "write this new information on the database". DELETE means delete and PUT means update.
- JSON is a format to encode information so that it travels in your requests without any troubles.
- Concurrecny means that your app will wait for the server to respond, instead of crashing due to your processor being faster than your internet connection.
- REST API are basically what you create that allows you to make machines communicate with each other.
- Docker is a thing that makes your life easier by virtualizing your environment, just learn the basic commands for now.


## Understanding the Vapor template

A Vapor project is full of files and dependancies and it can be daunting, but it's actually made of three fundamental parts:

1) Controllers
2) Migrations
3) Models

Understanding how these works allow you to start to tinker with code really quickly.

Controllers are the code that allow you to manage your http requests (POST, GET, etc.). In here you can write swifty code about what should happen to each request. Each request is going to have it's own function, so it's really easy to understand it's structure.

Migrations is a confusing term that means "make changes to your database". Imagine that your DB is a huge spreadsheet, if you want to create a new sheet or define the headers of each column you are going to do it with migrations. Migrations are something you manually launch when you need them. For example to create a new table or update it.

Models are the data you are manipulating and you want to store in your database. That's it.

## Create something with Vapor

First you create your Model. This is a representation of the data you want to store. You give it an unique ID and then decide all the fields you need to store. Here for example I just store a message and a user inside a table called "messages".

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



Then you create the Migration: you basically tell Vapor "hey, create a new table in the database for this new model I made".

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

Now you have a model and a database that can store it, the controller is what allows you to interact with it. It all starts with this function, where you can decide what other functions will be called for each htttp request.

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

For example, if you use a get call, the "index" function will be called and this code will be exectued extracting a random good vibe from the database.

```swift
    func index(req: Request) async throws -> String {
        guard let message = try await Message.query(on: req.db).all().randomElement() else {
            return "No good vibes yet :("
        }
        return "Your good vibe is \(message.message) from \(message.from)"
    }
```


## Interact with your app

Your app doesn't have a graphical interface and you give commands to it via web requests. An example of a web request is a GET one, it's the one you do each time you write a website domain on the address bar. This is the easiset to do, you can connect to your app the same way just by going to your own computer's ip (http://127.0.0.1:8080/). Copy paste it on the address bar of your browser with the app running to see for yourself!

If you want to do other kind of request you are going to need other tools, there are many online ([Postman](https://www.postman.com/), [Insomnia](https://insomnia.rest/)) that you can download. These tools allow you to send hand-crafted requests to your address containing whatever you want in them, allowing you to test and interact with your application.


## That's it


This is a really simplistic overview of Vapor designed to get coders without a techincal background up to speed quickly, so that you can actually tinker with code and Vapor. If you want to get serious there's a lot of amazing documentation around te web and a great starting point is the [official documentation](https://docs.vapor.codes/4.0/ "official documentation").
