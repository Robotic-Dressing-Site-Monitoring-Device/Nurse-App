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
                let docID = doc.documentID
                
                let firstName = data["firstName"] as? String ?? "Unknown"
                let lastName = data["lastName"] as? String ?? "Unknown"
                let location = data["location"] as? String ?? "Room TBD"
                let profileImageURL = data["profileImageURL"] as? String ?? ""
                
                var dressingStatus: DressingStatus = .good
                var symptom: Symptom = .none
                
                db.collection("patients").document(docID)
                    .collection("photos")
                    .order(by: "time", descending: true)
                    .limit(to: 1)
                    .getDocuments { snap, err in
                        if let photoData = snap?.documents.first?.data() {
                            let issueRaw = (photoData["issue"] as? String ?? "none").lowercased()
                            let statusRaw = (photoData["status"] as? String ?? "good").lowercased()
                            
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
                            notes: self.loadNotesFromUserDefaults(for: index)
                        )
                        
                        DispatchQueue.main.async {
                            updatedList.append(patient)
                            
                            if updatedList.count == documents.count {
                                self.patientList = updatedList
                                print("patientList updated with \(updatedList.count) patients")
                                if let first = updatedList.first {
                                    self.currentPatient = Binding(get: { first }, set: { _ in })
                                }
                            }
                        }
                    }
            }
        }
    }
    // MARK: - Local notes storage
    func saveNotesToUserDefaults(for patient: Patient) {
        let key = "notes_\(patient.id)"
        if let encoded = try? JSONEncoder().encode(patient.notes) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    func loadNotesFromUserDefaults(for patientID: Int) -> [Note] {
        let key = "notes_\(patientID)"
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([Note].self, from: data) {
            return decoded
        }
        return []
    }
    func recordNotes(notes: String) {
        let newNote = Note(text: notes, timestamp: Date())

        if let currPatient = currentPatient {
            if let index = patientList.firstIndex(where: { $0.id == currPatient.id }) {
                patientList[index].notes.append(newNote)

                var updated = currPatient.wrappedValue
                updated.notes.append(newNote)
                currPatient.wrappedValue = updated

                // ✅ 本地儲存
                saveNotesToUserDefaults(for: updated)
            }
        }
    }

}
