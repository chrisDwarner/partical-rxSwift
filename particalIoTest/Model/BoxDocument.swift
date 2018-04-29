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
}

extension BoxDocument:Hashable {
    var hashValue: Int {
        return self.key.hashValue
    }
}

