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
        patientID: 1,
        time: Date(),
        image: UIImage(named: "Image") ?? UIImage()
    )
    
    static let sampleStatus = patientStatus(
        dressingStatus: .good,
        symptom: .none
    )
    
    static var _samplePatient = Patient(
        id: 1,
        firstName: "John",
        lastName: "Wang",
        location: "Room 777",
        status: sampleStatus,
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        photo: samplePhoto
    )
    
    static var samplePatient: Binding<Patient> {
        Binding<Patient>(
            get: { _samplePatient },
            set: { _samplePatient = $0 }
        )
    }
    
    static func sampleManager() -> PatientManager {
        let manager = PatientManager()
        manager.currentPatient = samplePatient
        manager.patientList = [samplePatient.wrappedValue]
        return manager
    }
}
