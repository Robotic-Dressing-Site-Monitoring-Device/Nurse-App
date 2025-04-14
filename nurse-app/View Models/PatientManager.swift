//
//  PatientManager.swift
//  nurse-app
//
//  Created by Chang, Daniel Soobin on 3/3/25.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class PatientManager: ObservableObject {
    @Published var patientList: [Patient] = []
    @Published var currentPatient: Binding<Patient>?

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
        return symptom.displayName
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

    func loadPatientsFromFirestore() {
        let db = Firestore.firestore()
        self.patientList = []

        db.collection("patients").getDocuments { snapshot, error in
            if let error = error {
                print("Error loading patients: \(error)")
                return
            }

            guard let documents = snapshot?.documents else { return }

            let group = DispatchGroup()

            for (index, doc) in documents.enumerated() {
                let data = doc.data()
                let docID = doc.documentID

                let firstName = data["firstName"] as? String ?? "Unknown"
                let lastName = data["lastName"] as? String ?? "Unknown"
                let location = data["location"] as? String ?? "Room TBD"
                let profileImageURL = data["profileImageURL"] as? String ?? ""


                var dressingStatus: DressingStatus = .good
                var symptom: Symptom = .none

                group.enter()

                db.collection("patients").document(docID)
                    .collection("photos")
                    .order(by: "time", descending: true)
                    .limit(to: 1)
                    .getDocuments { snap, err in
                        if let photoData = snap?.documents.first?.data() {
                            let issueRaw = (photoData["issue"] as? String ?? "none").lowercased()
                            let statusRaw = (photoData["status"] as? String ?? "good").lowercased()

                            print("\n Latest photo data: \(docID):")
                            print("IssueRaw = \(issueRaw) → Symptom = \(Symptom.fromRawFirestore(issueRaw))")
                            print("StatusRaw = \(statusRaw) → DressingStatus = \(DressingStatus.fromRawFirestore(statusRaw))")

                            symptom = Symptom.fromRawFirestore(issueRaw)
                            dressingStatus = DressingStatus.fromRawFirestore(statusRaw)
                        }

                        let patient = Patient(
                            id: index,
                            firstName: firstName,
                            lastName: lastName,
                            location: location,
                            status: patientStatus(dressingStatus: dressingStatus, symptom: symptom),
                            description: "Loaded from Firestore",
                            profileImageURL: profileImageURL,
                            injuryPhotos: [],
                            notes: []

                        )

                        DispatchQueue.main.async {
                            self.patientList.append(patient)
                            print("Added patient: \(firstName) \(lastName)")
                            print("Final status = \(dressingStatus), symptom = \(symptom)")
                            group.leave()
                        }
                    }
            }

            group.notify(queue: .main) {
                print("Latest statuses loaded")
                if let first = self.patientList.first {
                    self.currentPatient = Binding(get: { first }, set: { _ in })
                }
            }
        }
    }
}
