//
//  Patient Models.swift
//  nurse-app
//
//  Created by Chang, Daniel Soobin on 3/3/25.
//

import Foundation
struct Patient: Identifiable {
    let id: Int
    let firstName: String
    let lastName: String
    var location: String
    //...
}

