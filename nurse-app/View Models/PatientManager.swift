//
//  PatientManager.swift
//  nurse-app
//
//  Created by Chang, Daniel Soobin on 3/3/25.
//

import Foundation
class PatientManager : ObservableObject {
    @Published var patientList: [Patient] = []
    @Published var currentPatient: Patient?
    
    init() {
        // Placeholder code
        for i in 0..<10 {
            let patient: Patient = Patient(id: i, firstName: "Patient \(i) First Name", lastName: "Patient \(i) Last Name", location: "Room \(i))")
            patientList.append(patient)
        }
    }
}
