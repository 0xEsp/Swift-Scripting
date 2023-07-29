
import AnyCodable
import Foundation

// MARK: - Model

enum AvailableChatNames: String, CaseIterable {
    case manu = "Espeso"
    case manu2 = "Manu 💙"
    case olga = "Olga 👑💙"
    case olga2 = "Olga Cardiel"
    case unowned = "Desconocido"

    func author() -> ChatResponseAuthor {
        var name = ""

        switch self {
        case .manu, .manu2: name = AvailableChatNames.manu2.rawValue
        case .olga, .olga2: name = AvailableChatNames.olga.rawValue
        default: name = AvailableChatNames.unowned.rawValue
        }

        return ChatResponseAuthor(id: name.generateUUID().uuidString, firstName: name)
    }
}

// MARK: - Input

struct ChatRequest: Codable {
    var date: String
    var subTexts: [AnyCodable]

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let container = try decoder.singleValueContainer()
        let dictionary = try container.decode([String: AnyCodable].self)
        let columnsDict = dictionary.filter { $0.key.lowercased().contains("column") }

        // Properties

        date = try values.decode(String.self, forKey: .date)
        subTexts = columnsDict.map { $0.value }
    }
}

// MARK: - Output

struct ChatResponse: Codable {
    let id: UUID
    let createdAt: Date
    let author: ChatResponseAuthor
    let type: String
    let status: String
    let text: AnyCodable

    init(createdAt: Date, author: ChatResponseAuthor, text: AnyCodable) {
        id = UUID()
        self.createdAt = createdAt
        self.author = author
        type = "text"
        status = "delivered"
        self.text = text
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(createdAt.toString(), forKey: .createdAt)
        try container.encode(author, forKey: .author)
        try container.encode(type, forKey: .type)
        try container.encode(status, forKey: .status)
        try container.encode(text, forKey: .text)
    }
}

struct ChatResponseAuthor: Codable {
    let id: String
    let firstName: String
    // let lastName: String
}

// MARK: - Methods

func mapChatModelToNewInstance(_ oldModel: [ChatRequest]) -> [ChatResponse] {
    var responses = [ChatResponse]()

    for (index, request) in oldModel.enumerated() {
        let messageDateAndPerson = request.date.components(separatedBy: " - ")
        let requestDate = messageDateAndPerson.first?.toDate(withFormat: "dd-MM-yy HH:mm:ss")
        let requestPerson = messageDateAndPerson.last?.components(separatedBy: ": ")

        let responseDate = requestDate ?? responses[index - 1].createdAt
        let responsePerson = (requestPerson?.first?.isValidChatName() ?? false) ?
            requestPerson!.first! :
            responses[index - 1].author.firstName
        let name = AvailableChatNames(rawValue: responsePerson) ?? .unowned

        let responseModel = ChatResponse(
            createdAt: responseDate,
            author: name.author(),
            text: AnyCodable(requestPerson?.last ?? "No puede ser... por que no hay texto :(")
        )

        responses.append(responseModel)

        request.subTexts.forEach {
            let responseModel = ChatResponse(createdAt: responseDate, author: name.author(), text: $0)
            responses.append(responseModel)
        }
    }

    return responses
}
