//
//  Utils.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 10/06/26.
//

import Foundation

enum UserDefaultsKey: String {
    case albumLength
    case userPoints
    case lastDailyRewardDate
    case lastRewardDate
}

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private init() {}
    
    // MARK: - Native values
    
    func save(_ value: Int, forKey key: UserDefaultsKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func getInt(forKey key: UserDefaultsKey) -> Int {
        UserDefaults.standard.integer(forKey: key.rawValue)
    }
    
    func save(_ value: Date, forKey key: UserDefaultsKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func getDate(forKey key: UserDefaultsKey) -> Date? {
        UserDefaults.standard.object(forKey: key.rawValue) as? Date
    }
    
    func save(_ value: String, forKey key: UserDefaultsKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func getString(forKey key: UserDefaultsKey) -> String? {
        UserDefaults.standard.string(forKey: key.rawValue)
    }
    
    func save(_ value: Bool, forKey key: UserDefaultsKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func getBool(forKey key: UserDefaultsKey) -> Bool {
        UserDefaults.standard.bool(forKey: key.rawValue)
    }
    
    // MARK: - Codable objects
    
    func saveObject<T: Encodable>(_ value: T, forKey key: UserDefaultsKey) {
        do {
            let data = try JSONEncoder().encode(value)
            UserDefaults.standard.set(data, forKey: key.rawValue)
            print("Saved object:", key.rawValue)
        } catch {
            print("Save object error:", error)
        }
    }
    
    func getObject<T: Decodable>(_ type: T.Type, forKey key: UserDefaultsKey) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key.rawValue) else {
            print("No data for key:", key.rawValue)
            return nil
        }
        
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            print("Decode object error:", error)
            return nil
        }
    }
    
    func remove(forKey key: UserDefaultsKey) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
