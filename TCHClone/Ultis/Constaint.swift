//
//  Constaint.swift
//  TCHClone
//
//  Created by Trần Huy on 5/2/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import Firebase

// MARK: - Key API GoogleMaps
let API_KEY = "AIzaSyAFHkS7YIReMxxdMqDsQt9ZP7ylQ0UcT9U"
let APP_ID_ONESIGNAL = "0133d280-1660-415e-a263-5b83bb191078"

// MARK: - Root References

let DB_REF = Database.database().reference()
let STORAGE_REF = Storage.storage().reference()

// MARK: - Database References

let USER_REF = DB_REF.child("users")
