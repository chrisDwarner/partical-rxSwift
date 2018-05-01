//
//  BoxDocument.swift
//  particalIoTest
//
//  Created by chris warner on 4/28/18.
//  Copyright © 2018 chris warner. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

func ==(lhs: BoxDocument, rhs:BoxDocument) -> Bool {
    return (lhs.key.value == rhs.key.value &&
        lhs.device_id.value == rhs.device_id.value &&
        lhs.hashValue == rhs.hashValue)
}

struct BoxDocument: Equatable {
    let key:Variable<String> = Variable<String>("")
    let value:Variable<String> = Variable<String>("")
    let scope:Variable<String> = Variable<String>("")
    let device_id:Variable<String> = Variable<String>("")
    let product_id:Variable<Int> = Variable<Int>(0)
    let updated_at:Variable<String> = Variable<String>("")

    init( dictionary: [String: Any]) {
        if let keyName = dictionary["key"] as? String,
            let valueItem = dictionary["value"] as? String,
            let scopeItem = dictionary["scope"] as? String,
            let deviceIdItem = dictionary["device_id"] as? String,
            let productIdItem = dictionary["product_id"] as? Int,
            let updatedItem = dictionary["updated_at"] as? String {
                key.value = keyName
                value.value = valueItem
                scope.value = scopeItem
                device_id.value = deviceIdItem
                product_id.value = productIdItem
                updated_at.value = updatedItem
            }
    }

    var dictionary: [String:Any] {
        return [
            "key": key.value,
            "value": value.value,
            "scope": scope.value,
            "device_id": device_id.value,
            "product_id": product_id.value,
            "updated_at": updated_at.value
        ]
    }
}

extension BoxDocument:Hashable {
    var hashValue: Int {
        return self.key.value.hashValue
    }
}

