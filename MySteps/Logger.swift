//
//  Logger.swift
//  MySteps
//
//  Created by alex on 02/05/2024.
//

import OSLog

class Logger: ObservableObject {
    private var osLog: OSLog

    init(subsystem: String, category: String) {
        self.osLog = OSLog(subsystem: subsystem, category: category)
    }

    func log(_ message: String, type: OSLogType = .default) {
        os_log("%{public}@", log: osLog, type: type, message)
    }
}
