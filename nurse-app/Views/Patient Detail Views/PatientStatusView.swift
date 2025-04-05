//
//  PatientStatusView.swift
//  nurse-app
//
//  Created by Chang, Daniel Soobin on 3/3/25.
//


import SwiftUI

struct PatientStatusView: View {
    @EnvironmentObject var patientManager: PatientManager
    @Binding var patient: Patient
    @State var nurseNotes: String = ""
    @State private var editingNotes: Bool = false
    @State private var titleVisible = false


    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea(edges: .bottom)
            patientManager.colorForStatus(patient.status.dressingStatus)
                .opacity(0.2)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    if let latestInjuryPhoto = patient.injuryPhotos.first {
                        VStack {
                            Image(uiImage: latestInjuryPhoto.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 250, height: 250)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(radius: 5)

                            Text("Taken on: \(patientManager.formattedDate(latestInjuryPhoto.time))")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    } else {
                        Text("No injury photo available")
                    }

                    HStack {
                        Text("Status:")
                            .font(.headline)
                            .foregroundColor(.black)
                        RoundedRectangle(cornerRadius: 5)
                            .fill(patientManager.colorForStatus(patient.status.dressingStatus))
                            .frame(width: 20, height: 20)
                    }
                    .padding(.vertical, 5)
                    Spacer().frame(height: 50)
                    
                    VStack(alignment: .leading, spacing: 15) {

                        Text("Identified Issue: \(patientManager.descriptionForSymptom(patient.status.symptom))")
                            .foregroundColor(.black)
                        Text("Location: \(patient.location)")
                            .foregroundColor(.black)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.ButtonColor)
                    .cornerRadius(10)
                    
                    Spacer().frame(height: 50)

                    HStack(spacing: 15) {
                        NavigationLink(destination: RecentStatusView(patient: $patient)) {
                            Text("Recent Status")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.ButtonColor)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }

                        Button(action: {
                            editingNotes = true
                        }) {
                            Text("Take Notes")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.ButtonColor)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                    }
                }
                .padding()
            }

            if editingNotes {
                EditingPopup(notesPopup: $editingNotes, nurseNotes: $nurseNotes)
            }
        }

    }
}



// Custom popup for textfields
struct EditingPopup : View {
    @EnvironmentObject var patientManager: PatientManager
    @Binding var notesPopup: Bool
    @Binding var nurseNotes: String
    
    var body: some View {
        if let patient = patientManager.currentPatient {
            if notesPopup {
                ZStack {
                    // Dimmed Background
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        Text("Enter your observations here.")
                            .font(.headline)
                            .padding()
                        TextField("Start writing...", text: $nurseNotes)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        HStack {
                            Button("Cancel") {
                                notesPopup = false
                            }
                            .padding()

                            Spacer()

                            Button("Submit") {
                                print("Before Submit: \(patient.description)")
                                if !nurseNotes.isEmpty {
                                    patientManager.recordNotes(notes: nurseNotes)
                                    notesPopup = false
                                    print("After Submit: \(patient.description)")
                                }
                                nurseNotes = ""
                            }
                            .padding()
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .frame(maxWidth: 300)
                }
            }
        }
    }
    
}

#Preview {
    PatientStatusView(patient: SampleData.samplePatient)
        .environmentObject(SampleData.sampleManager())
}
