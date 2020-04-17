//
//  RabbitMQConnection.swift
//  Hive2D
//
//  Created by John Phua on 17/04/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import RMQClient

class RabbitMQConnection {
    static let shared = RabbitMQConnection()

    let conn: RMQConnection
    private init() {
        conn = RMQConnection(uri: RabbitMQConstants.connectionURI,
                             delegate: RabbitMQDebug())
        conn.start()
    }
}
