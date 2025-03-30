//
//  Patient Models.swift
//  nurse-app
//
//  Created by Chang, Daniel Soobin on 3/3/25.
//

import Foundation
import SwiftUI

struct Patient: Identifiable {
    let id: Int
    let firstName: String
    let lastName: String
    var location: String
    
    var status: patientStatus
    
    var description: String
    var photo: Photo
    
    init(id: Int, firstName: String, lastName: String, location: String, status: patientStatus, description: String, photo: Photo) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.location = location
        self.status = status
        self.description = description
        self.photo = photo
    }
}

struct Photo: Identifiable{
    let id: Int
    let patienID: Int
    let time: Date
    let image: UIImage
}

struct patientStatus {
    var dressingStatus: DressingStatus
    var symptom: Symptom
}

enum DressingStatus: String {
    case good = "Good"
    case possibleDanger = "Patient may require care"
    case urgent = "Needs Immediate Attention"
}

enum Symptom: String{
    case none = "No symptoms"
    case redness = "Skin Redness"
    case pus = "Pus"
    case blood = "Blood"
    case dressingDmg = "Dressing Damage"
}
