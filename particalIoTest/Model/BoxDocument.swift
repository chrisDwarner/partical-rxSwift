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
        guard let keyName = dictionary["key"] as? String,
        let valueItem = dictionary["value"] as? String,
        let scopeItem = dictionary["scope"] as? String,
        let deviceIdItem = dictionary["device_id"] as? String,
        let productIdItem = dictionary["product_id"] as? Int,
        let updatedItem = dictionary["updated_at"] as? String
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
}

extension BoxDocument:Hashable {
    var hashValue: Int {
        return self.key.hashValue
    }
}

