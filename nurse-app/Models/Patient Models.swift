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
    var injuryPhotos: [Photo]
    var notes: [Note]


    
    init(id: Int, firstName: String, lastName: String, location: String, status: patientStatus, description: String, photo: Photo, injuryPhotos: [Photo], notes: [Note] = []) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.location = location
        self.status = status
        self.description = description
        self.photo = photo
        self.injuryPhotos = injuryPhotos
        self.notes = notes

    }
}

struct Photo: Identifiable{
    let id: Int
    let patientID: Int
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

struct Note: Identifiable {
    let id = UUID()
    let text: String
    let timestamp: Date
}
