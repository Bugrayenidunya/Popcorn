//
//  UserDefaultsManager.swift
//  Popcorn
//
//  Created by Enes Buğra Yenidünya on 26.04.2022.
//

import Foundation

// MARK: - ObjectSavable
protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

// MARK: - UserDefaultsManager
final class UserDefaultsManager: ObjectSavable {
    
    // MARK: Properties
    static let shared: UserDefaultsManager = .init()
    
    // MARK: Functions
    func setObject<Object>(_ object: Object, forKey: String) throws where Object : Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            UserDefaults.standard.set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object : Decodable {
        guard let data = UserDefaults.standard.data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}
