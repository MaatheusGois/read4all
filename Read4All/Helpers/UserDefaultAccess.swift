//
//  UserDefaultAccess.swift
//  Read4All
//
//  Created by Matheus Gois on 03/05/23.
//

import Foundation

@propertyWrapper struct UserDefaultAccess<T: Codable> {
    let key: String
    let defaultValue: T
    let userDefaults: UserDefaultsService

    init(
        key: Key,
        defaultValue: T,
        userDefaults: UserDefaultsService = UserDefaults.standard
    ) {
        self.key = key.rawValue
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    var wrappedValue: T {
        get {
            return userDefaults.value(T.self, forKey: key) ?? defaultValue
        }
        set {
            userDefaults.set(encodable: newValue, forKey: key)
        }
    }
}

protocol UserDefaultsService {
    func set<T: Encodable>(encodable: T, forKey key: String)
    func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T?
}

extension UserDefaults: UserDefaultsService {
    func set<T: Encodable>(encodable: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(encodable) {
            set(data, forKey: key)
        }
    }

    func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = object(forKey: key) as? Data,
            let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }
        return nil
    }
}
