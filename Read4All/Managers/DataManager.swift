//
//  DataManager.swift
//  Read4All
//
//  Created by Matheus Gois on 03/05/23.
//

import Foundation

// Class

struct DataStorage {

    // Properties

    @UserDefaultAccess(key: .lastText, defaultValue: "")
    static var lastText: String

    @UserDefaultAccess(key: .lastTime, defaultValue: .init())
    static var lastTime: Int
}
