
import CryptoKit
import Foundation

extension String {
    func toDate(withFormat format: String = "dd-MM-yy HH:mm") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format

        return dateFormatter.date(from: self)
    }

    func isValidChatName() -> Bool {
        AvailableChatNames.allCases.first(where: { $0.rawValue == self }) != nil
    }

    func generateUUID() -> NSUUID {
        let hash = Insecure.SHA1.hash(data: Data(utf8))

        var truncatedHash = Array(hash.prefix(16))
        truncatedHash[6] &= 0x0F // Clear version field
        truncatedHash[6] |= 0x50 // Set version to 5

        truncatedHash[8] &= 0x3F // Clear variant field
        truncatedHash[8] |= 0x80 // Set variant to DCE 1.1

        return NSUUID(uuidBytes: truncatedHash)
    }
}

extension Date {
    func toString(withFormat _: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Set your desired date format

        return dateFormatter.string(from: self)
    }
}
