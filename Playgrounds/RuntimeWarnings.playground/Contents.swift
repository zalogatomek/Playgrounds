import UIKit

// MARK: - Runtime warning

fileprivate extension String {
    var fileName: String { URL(fileURLWithPath: self).lastPathComponent }
}

func runtimeWarning(_ message: String, file: String = #file, line: Int = #line) {
    //#if DEBUG
    DispatchQueue.global(qos: .userInteractive).async {
        // If you got here, please check console for more info
        _ = UIApplication.shared.windows
        print("Runtime warning: \(message): file \(file.fileName), line \(line)")
    }
    //#endif
}


// MARK: - Call to see what will happen

// EXC_BAD)INSTRUCTION
// Fatal error: Sorry, game over: file RuntimeWarnings.playground, line XX
// fatalError("Sorry, game over")

// EXC_BAD_INSTRUCTION
// Fatal error: This not supposted to happen: file RuntimeWarnings.playground, line XX
// assertionFailure("This not supposted to happen")

// No error + purple warning in runtime (only in project, not in a playground)
// Runtime warning: Hi, I'm runtime warning, and I'm in purple: file RuntimeWarnings.playground, line XX
runtimeWarning("Hi, I'm runtime warning, and I'm in purple")
