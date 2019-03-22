
import FluentSQLite
import Vapor

enum TalkType: Int, Content {
    case talk
    case demo
}

enum TalkLevel: Int, Content {
    case beginner
    case advanced
}


final class Event: SQLiteModel {
    var id: Int?
    
    var title: String
    var description: String
    var type: TalkType
    var level: TalkLevel
    var isSelectedEvent: Bool
    var authorName: String
    var user: User.ID
    
    init(id: Int? = nil, title: String, description: String, type: TalkType, level: TalkLevel, user: User.ID, authorName: String, isSelectedEvent: Bool) {
        self.id = id
        self.title = title
        self.description = description
        self.type = type
        self.level = level
        self.user = user
        self.authorName = authorName
        self.isSelectedEvent = isSelectedEvent
    }
}

extension Event: Content {}
extension Event: Parameter {}

extension Event {
    var event: Parent<Event, User> {
        return parent(\.user)
    }
}

extension Event: Migration {
    // 2
    static func prepare(
        on connection: SQLiteConnection
        ) -> Future<Void> {
        // 3
        return Database.create(self, on: connection) { builder in
            // 4
            try addProperties(to: builder)
            // 5
            builder.reference(from: \.user, to: \User.id)
        }
    }
}
