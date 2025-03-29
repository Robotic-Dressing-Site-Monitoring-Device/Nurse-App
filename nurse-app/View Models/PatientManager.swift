//
//  PatientManager.swift
//  nurse-app
//
//  Created by Chang, Daniel Soobin on 3/3/25.
//

import Foundation
import SwiftUI

class PatientManager: ObservableObject {
    @Published var patientList: [Patient] = []
    @Published var currentPatient: Patient?

    init() {
        for i in 0..<10 {
            let status = patientStatus(
                dressingStatus: .good,
                symptom: .none
            )
            
            let photo = Photo(
                id: i,
                patienID: i,
                time: Date(),
                image: UIImage(systemName: "person.fill") ?? UIImage()
            )
            
            let patient = Patient(
                id: i,
                firstName: "Patient\(i)",
                lastName: "Last\(i)",
                location: "Room \(i)",
                status: status,
                description: "No issues detected.",
                photo: photo
            )
            
            patientList.append(patient)
        }
    }
}
