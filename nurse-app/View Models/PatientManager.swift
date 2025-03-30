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
            var status: patientStatus
            if i % 2 == 0 {
                status = patientStatus(
                    dressingStatus: .good,
                    symptom: .none
                )
            }
            else if i % 3 == 0 {
                status = patientStatus(
                    dressingStatus: .possibleDanger,
                    symptom: .redness
                )
            }
            else {
                status = patientStatus(
                    dressingStatus: .urgent,
                    symptom: .blood
                )
            }
            
            
            let photo = Photo(
                id: i,
                patienID: i,
                time: Date(),
                image: UIImage(systemName: "person.fill") ?? UIImage()
            )
            
            let patient = Patient(
                id: i,
                firstName: "First\(i)",
                lastName: "Last\(i)",
                location: "Room \(i)",
                status: status,
                description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                photo: photo
            )
            
            patientList.append(patient)
        }
    }
    
    func setPatient(patient: Patient) {
        self.currentPatient = patient
        print("Current patient is \(patient.id)")
    }
    
    func colorForStatus(_ status: DressingStatus) -> Color {
        switch status {
        case .good:
            return .green
        case .possibleDanger:
            return .yellow
        case .urgent:
            return .red
        }
    }

    func descriptionForSymptom(_ symptom: Symptom) -> String {
        switch symptom {
        case .none:
            return "No symptoms"
        default:
            return symptom.rawValue
        }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
    
    func recordNotes() {
        
    }
}
