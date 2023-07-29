
import AnyCodable
import Darwin
import Foundation
import TSCBasic
import TSCUtility

/**
 * exec script: swift run parser
 * exec script with arguments: swift run parser --input carpeta/fichero.json --arg2 carpeta/fichero-fin.json
 *
 * Guides:
 * https://github.com/artemnovichkov/Swift-For-Scripting
 * https://www.fivestars.blog/articles/ultimate-guide-swift-executables/
 * https://medium.com/fink-oslo/scripting-with-swift-c8b929d1a7a3
 *
 * Parse .txt to .json:
 * https://blog.aspose.com/cells/convert-txt-to-json-online/
 */

Arguments.main()

guard let arguments = try? Arguments.parse() else { exit(EXIT_FAILURE) }

AvailableDirectories.listAll()

guard let directoryInput = Int(readLine() ?? ""),
      let directory = AvailableDirectories(rawValue: directoryInput)
else {
    print("El directorio introducido no es correcto, intentelo de nuevo.")
    exit(EXIT_FAILURE)
}

guard let dir = FileManager.default.urls(for: directory.toFileManagerPath(), in: .userDomainMask).first else {
    print("Cannot retreive document directory")
    exit(EXIT_FAILURE)
}

let fileReadURL = dir.appendingPathComponent(arguments.input)
let fileWriteURL = dir.appendingPathComponent(arguments.output)

let animation = PercentProgressAnimation(
    stream: stdoutStream,
    header: "Con cariño y amor ✨💙"
)

do {
    animation.update(step: 1, total: 5, text: "Decodificación del fichero...")

    let jsonData = try Data(contentsOf: fileReadURL)
    let decoder = JSONDecoder()
    let model = try decoder.decode([ChatRequest].self, from: jsonData)

    animation.update(step: 2, total: 5, text: "Mapeo del modelo del fichero al modelo de respuesta...")

    let finalModel = mapChatModelToNewInstance(model)

    animation.update(step: 3, total: 5, text: "Encodificación del modelo del respuesta a formato JSON...")

    let jsonEncoder = JSONEncoder()
    jsonEncoder.outputFormatting = .prettyPrinted
    let fileJson = try jsonEncoder.encode(finalModel)
    let json = String(data: fileJson, encoding: String.Encoding.utf8)

    animation.update(step: 4, total: 5, text: "Escritura del JSON en disco...")

    try json?.write(to: fileWriteURL, atomically: false, encoding: .utf8)

    animation.update(step: 5, total: 5, text: "COMPLETADO ✅")
    animation.complete(success: true)
} catch {
    animation.complete(success: false)
    animation.clear()

    print("Error trying to read file: \(error)")
}
