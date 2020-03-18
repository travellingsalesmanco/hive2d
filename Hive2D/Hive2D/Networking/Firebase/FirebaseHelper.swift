//
//  FirebaseHelper.swift
//  Hive2D
//
//  Created by John Phua on 19/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Firebase

struct FirebaseHelper {
    // Sets the first available lobby code using transactions
    static func setLobbyCode(for lobbyRef: DatabaseReference) {
        FirebaseConstants.gameCodeRef.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in

            let dataString = currentData.value as? String
            let prevCode = dataString ?? "0000"

            currentData.value = incrementCode(prevCode)
            return .success(withValue: currentData)
        }, andCompletionBlock: { error, committed, snapshot in
            if error != nil {
                return
            }

            guard let code = snapshot?.value else {
                return
            }
            if committed {
                FirebaseConstants.codeRef(ofLobby: lobbyRef).setValue(code)
            }
        })

    }

    private static func incrementCode(_ prev: String) -> String {
        guard let num = Int(prev) else {
            return "0000"
        }
        let new = (num + 1) % 10_000
        return String(format: "%04d", new)
    }
}
