//
//  Helper.swift
//  MusicTermApp
//
//  Created by 槙和馬 on 2021/08/25.
//

import Foundation
import UIKit
import Firebase

let userRef = Firestore.firestore().collection("users").document(uid)
var uid = "a"
