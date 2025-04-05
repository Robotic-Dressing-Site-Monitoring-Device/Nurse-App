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
    @Published var currentPatient: Binding<Patient>?

    init() {
        // Initializing Test patients
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
            
            
            let profilephoto = Photo(
                id: i,
                patientID: i,
                time: Date(),
                image: UIImage(named: "ProfilePhoto") ?? UIImage()
            )
            
            var injuryPhotos: [Photo] = []
                        for j in 0..<(2 + i % 2) {
                            let injuryPhoto = Photo(
                                id: j,
                                patientID: i,
                                time: Date().addingTimeInterval(TimeInterval(-j * 3600)),
                                image: UIImage(named: "InjuryPhoto") ?? UIImage()
                            )
                            injuryPhotos.append(injuryPhoto)
                        }
            
            let patient = Patient(
                id: i,
                firstName: "First\(i)",
                lastName: "Last\(i)",
                location: "Room \(i)",
                status: status,
                description: "No Nurse Notes So Far.",
                photo: profilephoto,
                injuryPhotos: injuryPhotos,
                notes: []

            )
            
            patientList.append(patient)
        }
    }
    
    func setPatient(patient: Binding<Patient>) {
        self.currentPatient = patient
        print("Current patient is \(patient.id)")
    }
    
    func colorForStatus(_ status: DressingStatus) -> Color {
        switch status {
        case .good:
            return Color.ListGreen
        case .possibleDanger:
            return Color.ListYellow
        case .urgent:
            return Color.ListRed
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
    
    func recordNotes(notes: String) {
        if let currPatient = currentPatient {
            if let index = patientList.firstIndex(where: { $0.id == currPatient.id }) {
                let newNote = Note(text: notes, timestamp: Date())
                patientList[index].notes.append(newNote)
            }
        }
    }


}
