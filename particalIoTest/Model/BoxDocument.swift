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

    init( dictionary: [String: Any]) {
        guard let array = dictionary["data"] as? [[String:Any]],
        let dict = array.first,            
            let keyName = dict["key"] as? String,
        let valueItem = dict["value"] as? String,
        let scopeItem = dict["scope"] as? String,
        let deviceIdItem = dict["device_id"] as? String,
        let productIdItem = dict["product_id"] as? Int,
        let updatedItem = dict["updated_at"] as? String
        else {
            fatalError()
        }
        key = keyName
        value = valueItem
        scope = scopeItem
        device_id = deviceIdItem
        product_id = productIdItem
        updated_at = updatedItem
    }

    var dictionary: [String:Any] {
        return [
            "key": key,
            "value": value,
            "scope": scope,
            "device_id": device_id,
            "product_id": product_id,
            "updated_at": updated_at
            ]
    }

//    static let testData: [BoxDocument] = {
//        let boxOne = BoxDocument(key: "temperature", value: "42", scope: "device", device_id: "255000000000000000000001", product_id: 1234, updated_at: "2018-08-29T09:12:33.001Z")
//        let boxTwo = BoxDocument(key: "weight", value: "100", scope: "device", device_id: "255000000000000000000002", product_id: 1234, updated_at: "2018-08-29T09:12:33.001Z")
//        let boxThree = BoxDocument(key: "battery", value: "90", scope: "device", device_id: "255000000000000000000003", product_id: 1234, updated_at: "2018-08-29T09:12:33.001Z")
//
//        return [boxOne, boxTwo, boxThree]
//    }()
}

extension BoxDocument:Hashable {
    var hashValue: Int {
        return self.key.hashValue
    }
}

