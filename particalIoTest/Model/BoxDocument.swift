//
//  BoxDocument.swift
//  particalIoTest
//
//  Created by chris warner on 4/28/18.
//  Copyright © 2018 chris warner. All rights reserved.
//

import Foundation

func ==(lhs: BoxDocument, rhs:BoxDocument) -> Bool {
    return (lhs.key == rhs.key &&
            lhs.device_id == rhs.device_id &&
            lhs.hashValue == rhs.hashValue)
}

struct BoxDocument: Equatable {
    let key:String
    let value:String
    let scope:String
    let device_id:String
    let product_id:Int
    let updated_at:String

    static let testData: [BoxDocument] = {
        let boxOne = BoxDocument(key: "temperature", value: "42", scope: "device", device_id: "255000000000000000000001", product_id: 1234, updated_at: "2018-08-29T09:12:33.001Z")
        let boxTwo = BoxDocument(key: "weight", value: "100", scope: "device", device_id: "255000000000000000000002", product_id: 1234, updated_at: "2018-08-29T09:12:33.001Z")
        let boxThree = BoxDocument(key: "battery", value: "90", scope: "device", device_id: "255000000000000000000003", product_id: 1234, updated_at: "2018-08-29T09:12:33.001Z")

        return [boxOne, boxTwo, boxThree]
    }()
}

extension BoxDocument:Hashable {
    var hashValue: Int {
        return self.key.hashValue
    }
}

