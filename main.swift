//
//  main.swift
//  MinecraftGameStub
//
//  Created by AnemoFlower on 2026/2/21.
//

import Foundation

let arguments: [String] = ProcessInfo.processInfo.arguments
guard arguments.count >= 3 else {
    print("Usage: \(arguments[0]) <java_path> <arguments>")
    exit(EXIT_FAILURE)
}

let executablePath: String = arguments[1]
let argv: [UnsafeMutablePointer<CChar>?] = ([executablePath] + arguments.dropFirst(2)).map { strdup($0) } + [nil]

argv.withUnsafeBufferPointer { argvBuffer in
    execv(executablePath, argvBuffer.baseAddress)
    print("Launch failed: execv errno=\(errno) \(String(cString: strerror(errno)))")
    exit(EXIT_FAILURE)
}
