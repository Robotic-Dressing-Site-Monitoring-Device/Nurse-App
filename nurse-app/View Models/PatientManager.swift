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
        case .good: return Color.ListGreen
        case .possibleDanger: return Color.ListYellow
        case .urgent: return Color.ListRed
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

    func loadPatientsFromFirestore() {
        let db = Firestore.firestore()

        db.collection("patients").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error loading patients: \(error)")
                return
            }

            guard let documents = snapshot?.documents else { return }

            var updatedList: [Patient] = []

            for (index, doc) in documents.enumerated() {
                let data = doc.data()

                let firstName = data["firstName"] as? String ?? "Unknown"
                let lastName = data["lastName"] as? String ?? "Unknown"
                let location = data["location"] as? String ?? "Room TBD"
                let profileImageURL = data["profileImageURL"] as? String ?? ""

                var dressingStatus: DressingStatus = .good
                var symptom: Symptom = .none
                let patientKey = "\(firstName.lowercased())_\(lastName.lowercased())"

                db.collection("patients").document(patientKey)
                    .collection("photos")
                    .order(by: "time", descending: true)
                    .limit(to: 1)
                    .getDocuments { snap, err in
                        if let photoData = snap?.documents.first?.data() {
                            let statusRaw = (photoData["status"] as? String ?? "good").lowercased()
                            if let issueArray = photoData["issue"] as? [String], let firstIssue = issueArray.first {
                                symptom = Symptom.fromRawFirestore(firstIssue)
                            } else if let issueString = photoData["issue"] as? String {
                                symptom = Symptom.fromRawFirestore(issueString)
                            }
                            dressingStatus = DressingStatus.fromRawFirestore(statusRaw)
                        }

                        self.loadNotesFromFirestore(for: patientKey) { notes in
                            let patient = Patient(
                                id: index,
                                firstName: firstName,
                                lastName: lastName,
                                location: location,
                                status: patientStatus(dressingStatus: dressingStatus, symptom: symptom),
                                description: "Loaded from Firestore",
                                profileImageURL: profileImageURL,
                                injuryPhotos: [],
                                notes: notes
                            )

                            DispatchQueue.main.async {
                                updatedList.append(patient)
                                if updatedList.count == documents.count {
                                    self.patientList = updatedList
                                    print("✅ patientList updated with \(updatedList.count) patients")
                                    if let first = updatedList.first {
                                        self.currentPatient = Binding(get: { first }, set: { _ in })
                                    }
                                }
                            }
                        }
                    }
            }
        }
    }

    func recordNotes(for patient: Patient, noteText: String) {
        let db = Firestore.firestore()
        let timestamp = Timestamp(date: Date())
        let patientKey = "\(patient.firstName.lowercased())_\(patient.lastName.lowercased())"

        let noteData: [String: Any] = [
            "text": noteText,
            "timestamp": timestamp
        ]

        db.collection("patients")
          .document(patientKey)
          .collection("notes")
          .document("\(timestamp.dateValue().timeIntervalSince1970)")
          .setData(noteData) { error in
              if let error = error {
                  print("Failed to save note: \(error)")
              } else {
                  print("Note saved for patient: \(patientKey)")
              }
          }
    }

    func loadNotesFromFirestore(for patientKey: String, completion: @escaping ([Note]) -> Void) {
        let db = Firestore.firestore()
        db.collection("patients")
            .document(patientKey)
            .collection("notes")
            .order(by: "timestamp", descending: false)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Failed to load notes: \(error)")
                    completion([])
                    return
                }

                guard let documents = snapshot?.documents else {
                    completion([])
                    return
                }

                let notes: [Note] = documents.compactMap { doc in
                    let data = doc.data()
                    guard let text = data["text"] as? String,
                          let timestamp = data["timestamp"] as? Timestamp else {
                        return nil
                    }
                    return Note(text: text, timestamp: timestamp.dateValue())
                }

                completion(notes)
            }
    }


    private var refreshTimer: Timer?

    func startAutoRefresh(interval: TimeInterval = 10.0) {
        refreshTimer?.invalidate()
        refreshTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            self.loadPatientsFromFirestore()
        }
    }

    func stopAutoRefresh() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
}
