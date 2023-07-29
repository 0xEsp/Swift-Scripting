
import Foundation

enum AvailableDirectories: Int, CaseIterable {
    case documents
    case desktop
    case downloads

    func toFileManagerPath() -> FileManager.SearchPathDirectory {
        switch self {
        case .desktop:
            return .desktopDirectory
        case .documents:
            return .documentDirectory
        case .downloads:
            return .downloadsDirectory
        }
    }

    static func listAll() {
        print("Escribe el numero sobre que directorio quieres trabajar")

        AvailableDirectories.allCases.forEach {
            switch $0 {
            case .desktop:
                print("\($0.rawValue). Escritorio")
            case .documents:
                print("\($0.rawValue). Documentos")
            case .downloads:
                print("\($0.rawValue). Descargas")
            }
        }
    }
}
