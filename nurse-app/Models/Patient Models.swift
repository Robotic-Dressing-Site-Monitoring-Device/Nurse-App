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
    var profileImageURL: String
    var injuryPhotos: [Photo]
    var notes: [Note]

    init(id: Int, firstName: String, lastName: String, location: String, status: patientStatus, description: String, profileImageURL: String, injuryPhotos: [Photo], notes: [Note] = []) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.location = location
        self.status = status
        self.description = description
        self.profileImageURL = profileImageURL
        self.injuryPhotos = injuryPhotos
        self.notes = notes
    }
}

struct Photo: Identifiable {
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
    case good
    case possibleDanger
    case urgent

    var displayName: String {
        switch self {
        case .good: return "Good"
        case .possibleDanger: return "Patient may require care"
        case .urgent: return "Needs Immediate Attention"
        }
    }

    static func fromRawFirestore(_ value: String) -> DressingStatus {
        switch value.lowercased() {
        case "good": return .good
        case "possibledanger", "possible_danger": return .possibleDanger
        case "urgent": return .urgent
        default: return .good
        }
    }
}

enum Symptom: String {
    case none
    case redness
    case pus
    case blood
    case dressingDmg

    var displayName: String {
        switch self {
        case .none: return "No symptoms"
        case .redness: return "Skin Redness"
        case .pus: return "Pus"
        case .blood: return "Blood"
        case .dressingDmg: return "Dressing Damage"
        }
    }

    static func fromRawFirestore(_ value: String) -> Symptom {
        switch value.lowercased() {
        case "none": return .none
        case "redness": return .redness
        case "pus": return .pus
        case "blood": return .blood
        case "dressingdmg", "dressing_dmg": return .dressingDmg
        default: return .none
        }
    }
}

struct Note: Identifiable {
    let id = UUID()
    let text: String
    let timestamp: Date
}
