//
//  Logger.swift
//  FirebaseDemoApp
//
//  Created by Yuki Okudera on 2021/07/24.
//

import Foundation

enum Logger {

    static func verbose(_ items: Any..., file: NSString = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let now = DateFormatter.shared.string(from: Date())
        let fileName = (file.deletingPathExtension as NSString).lastPathComponent
        print("💜 Verbose \(now) \(fileName) \(function) L\(line) >", items.toString)
        #endif
    }

    static func debug(_ items: Any..., file: NSString = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let now = DateFormatter.shared.string(from: Date())
        let fileName = (file.deletingPathExtension as NSString).lastPathComponent
        print("💚 Debug \(now) \(fileName) \(function) L\(line) >", items.toString)
        #endif
    }

    static func info(_ items: Any..., file: NSString = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let now = DateFormatter.shared.string(from: Date())
        let fileName = (file.deletingPathExtension as NSString).lastPathComponent
        print("💙 Info \(now) \(fileName) \(function) L\(line) >", items.toString)
        #endif
    }

    static func warning(_ items: Any..., file: NSString = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let now = DateFormatter.shared.string(from: Date())
        let fileName = (file.deletingPathExtension as NSString).lastPathComponent
        print("💛 Warning \(now) \(fileName) \(function) L\(line) >", items.toString)
        #endif
    }

    static func error(_ items: Any..., file: NSString = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let now = DateFormatter.shared.string(from: Date())
        let fileName = (file.deletingPathExtension as NSString).lastPathComponent
        print("🧡 Error \(now) \(fileName) \(function) L\(line) >", items.toString)
        #endif
    }

    static func fatal(_ items: Any..., file: NSString = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let now = DateFormatter.shared.string(from: Date())
        let fileName = (file.deletingPathExtension as NSString).lastPathComponent
        assertionFailure("❤️ Fatal \(now) \(fileName) \(function) L\(line) > \(items.toString)")
        #endif
    }
}

private extension Array {
    var toString: String {
        var str = ""
        self.forEach {
            str += "\($0) "
        }
        return String(str.dropLast())
    }
}

private extension DateFormatter {
    static let shared: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "HmsSSS", options: 0, locale: .current)
        return dateFormatter
    }()
}
