////
////  Sample.swift
////  nurse-app
////
////  Created by Chris Tseng on 3/29/25.
////
//
//
//import Foundation
//import SwiftUI
//
//struct SampleData {
//    
//    // Sample patient profile photos
//    static let samplePhotos: [Photo] = [
//        Photo(id: 1, patientID: 1, time: Date(), image: UIImage(named: "ProfilePhoto") ?? UIImage()),
//        Photo(id: 2, patientID: 2, time: Date(), image: UIImage(named: "ProfilePhoto") ?? UIImage()),
//        Photo(id: 3, patientID: 3, time: Date(), image: UIImage(named: "ProfilePhoto") ?? UIImage()),
//        Photo(id: 4, patientID: 4, time: Date(), image: UIImage(named: "ProfilePhoto") ?? UIImage()),
//        Photo(id: 5, patientID: 5, time: Date(), image: UIImage(named: "ProfilePhoto") ?? UIImage())
//    ]
//    
//    // Sample statuses for patients
//    static let sampleStatuses: [patientStatus] = [
//        patientStatus(dressingStatus: .good, symptom: .none),
//        patientStatus(dressingStatus: .possibleDanger, symptom: .redness),
//        patientStatus(dressingStatus: .urgent, symptom: .blood),
//        patientStatus(dressingStatus: .good, symptom: .dressingDmg),
//        patientStatus(dressingStatus: .possibleDanger, symptom: .pus)
//    ]
//    
//    // Sample injury photos for each patient
//    static let sampleInjuryPhotos: [[Photo]] = [
//        [
//            Photo(id: 1, patientID: 1, time: Date().addingTimeInterval(-3600), image: UIImage(named: "InjuryPhoto") ?? UIImage())
//        ],
//        [
//            Photo(id: 1, patientID: 2, time: Date().addingTimeInterval(-7200), image: UIImage(named: "InjuryPhoto") ?? UIImage())
//        ],
//        [
//            Photo(id: 1, patientID: 3, time: Date().addingTimeInterval(-10800), image: UIImage(named: "InjuryPhoto") ?? UIImage())
//        ],
//        [
//            Photo(id: 1, patientID: 4, time: Date().addingTimeInterval(-14400), image: UIImage(named: "InjuryPhoto") ?? UIImage())
//        ],
//        [
//            Photo(id: 1, patientID: 5, time: Date().addingTimeInterval(-18000), image: UIImage(named: "InjuryPhoto") ?? UIImage())
//        ]
//    ]
//    
//    // Define five sample patients with specific data
//    static var samplePatients: [Patient] {
//        return [
//            Patient(
//                id: 1,
//                firstName: "John",
//                lastName: "Wang",
//                location: "Room 777",
//                status: sampleStatuses[0],
//                description: "John Wang, a 45-year-old male, is recovering well from his injury.",
//                photo: samplePhotos[0],
//                injuryPhotos: sampleInjuryPhotos[0],
//                notes: [
//                    Note(text: "Initial check complete.", timestamp: Date())
//                ]
//            ),
//            Patient(
//                id: 2,
//                firstName: "Jane",
//                lastName: "Doe",
//                location: "Room 888",
//                status: sampleStatuses[1],
//                description: "Jane Doe, a 38-year-old female, requires further observation for redness.",
//                photo: samplePhotos[1],
//                injuryPhotos: sampleInjuryPhotos[1],
//                notes: [
//                    Note(text: "Redness observed. Monitoring closely.", timestamp: Date().addingTimeInterval(-3600))
//                ]
//            ),
//            Patient(
//                id: 3,
//                firstName: "Michael",
//                lastName: "Smith",
//                location: "Room 999",
//                status: sampleStatuses[2],
//                description: "Michael Smith, a 60-year-old male, needs immediate attention due to blood loss.",
//                photo: samplePhotos[2],
//                injuryPhotos: sampleInjuryPhotos[2],
//                notes: [
//                    Note(text: "Emergency treatment administered.", timestamp: Date().addingTimeInterval(-7200))
//                ]
//            ),
//            Patient(
//                id: 4,
//                firstName: "Alice",
//                lastName: "Johnson",
//                location: "Room 101",
//                status: sampleStatuses[3],
//                description: "Alice Johnson, a 25-year-old female, has mild dressing damage.",
//                photo: samplePhotos[3],
//                injuryPhotos: sampleInjuryPhotos[3],
//                notes: [
//                    Note(text: "Dressing change required.", timestamp: Date().addingTimeInterval(-10800))
//                ]
//            ),
//            Patient(
//                id: 5,
//                firstName: "David",
//                lastName: "Lee",
//                location: "Room 202",
//                status: sampleStatuses[4],
//                description: "David Lee, a 50-year-old male, has pus observed in the wound.",
//                photo: samplePhotos[4],
//                injuryPhotos: sampleInjuryPhotos[4],
//                notes: [
//                    Note(text: "Pus observed. Additional care needed.", timestamp: Date().addingTimeInterval(-14400))
//                ]
//            )
//        ]
//    }
//    
//    // Convert the sample patients into bindings
//    static var samplePatientBinding: [Binding<Patient>] {
//        return samplePatients.map { patient in
//            Binding<Patient>(
//                get: { patient },
//                set: { _ in } // Don't modify directly in the preview
//            )
//        }
//    }
//    
//    // Create and return a PatientManager with the sample data
//    static func sampleManager() -> PatientManager {
//        let manager = PatientManager()
//        manager.patientList = samplePatients
//        manager.currentPatient = Binding(get: { samplePatients[0] }, set: { _ in })
//        return manager
//    }
//}
