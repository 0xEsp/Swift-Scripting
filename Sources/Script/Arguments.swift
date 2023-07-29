
import ArgumentParser
import Foundation

struct Arguments: ParsableCommand {
    @Option(help: "Input file directory")
    var input: String

    @Option(help: "Ouput file directory")
    var output: String

    func run() throws {
        print("------------------------------------------\n🌍🕐 [REQUEST][TIME] \(Date())")
        print("PARAMS ✅")
        print(
            """
            input: \(input),
            output: \(output),
            \n
            """
        )
    }
}
