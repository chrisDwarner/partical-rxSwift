//
//  BoxDocuments.swift
//  particalIoTest
//
//  Created by chris warner on 4/28/18.
//  Copyright © 2018 chris warner. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class BoxDocuments {
    static let instance = BoxDocuments()

    var boxes:Variable<[BoxDocument]> = Variable([])
}
