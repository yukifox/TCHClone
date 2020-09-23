//
//  File.swift
//  TCHClone
//
//  Created by Trần Huy on 6/3/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import Foundation
class ConfigUser {
    static let shared = ConfigUser()
    static var user: User?
    private init() {}
}
