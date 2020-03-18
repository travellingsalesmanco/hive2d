//
//  FirebaseCodable.swift
//  Hive2D
//
//  Created by John Phua on 15/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Firebase

struct FirebaseCodable<T: Codable> {
    static func toDict(_ obj: T) -> Any? {
        guard let data = try? JSONEncoder().encode(obj) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: [])
    }
    
    static func fromDict(_ data: Any) -> T? {
        guard let lobbyData = try? JSONSerialization.data(withJSONObject: data, options: []) else {
            return nil
        }
        
        return try? JSONDecoder().decode(T.self, from: lobbyData)
    }
}
