//
//  Sample.swift
//  nurse-app
//
//  Created by Chris Tseng on 3/29/25.
//


import Foundation
import SwiftUI

struct SampleData {
    
    static let samplePhoto = Photo(
        id: 1,
        patienID: 1,
        time: Date(),
        image: UIImage(named: "Image") ?? UIImage()
    )
    
    static let sampleStatus = patientStatus(
        dressingStatus: .good,
        symptom: .none
    )
    
    static let samplePatient = Patient(
        id: 1,
        firstName: "John",
        lastName: "Wang",
        location: "Room 777",
        status: sampleStatus,
        description: "Preview test patient",
        photo: samplePhoto
    )
    
    static func sampleManager() -> PatientManager {
        let manager = PatientManager()
        manager.currentPatient = samplePatient
        manager.patientList = [samplePatient] 
        return manager
    }
}
