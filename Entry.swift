//
//  Entry.swift
//  MinecraftGameStub
//
//  Created by AnemoFlower on 2026/2/21.
//

import Foundation
import AppKit

func launch() {
    let arguments: [String] = ProcessInfo.processInfo.arguments
    guard arguments.count >= 3 else {
        print("Usage: \(arguments[0]) <java_path> <arguments>")
        exit(EXIT_FAILURE)
    }
    
    let executablePath: String = arguments[1]
    let argvStrings: [String] = [executablePath] + arguments.dropFirst(2)
    let argv: [UnsafeMutablePointer<CChar>?] = argvStrings.map { (s: String) -> UnsafeMutablePointer<CChar>? in
        strdup(s)
    } + [nil]
    
    argv.withUnsafeBufferPointer { (argvBuffer: UnsafeBufferPointer<UnsafeMutablePointer<CChar>?>) -> Void in
        execv(executablePath, argvBuffer.baseAddress)
        print("Launch failed: execv errno=\(errno) \(String(cString: strerror(errno)))")
        exit(EXIT_FAILURE)
    }
}

@MainActor
final class ApplicationDelegate: NSObject, NSApplicationDelegate {
    func applicationWillFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
        let _: CFRunLoopRunResult = CFRunLoopRunInMode(.defaultMode, 0.01, true)
        launch()
    }
}

@MainActor
@main
struct Main {
    private static let delegate: ApplicationDelegate = .init()
    
    static func main() {
        let app: NSApplication = NSApplication.shared
        app.delegate = delegate
        app.run()
    }
}
