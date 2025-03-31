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
    
    var body: some View {
        //if let patient = patientManager.currentPatient {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        VStack {
                            Image(uiImage: patient.photo.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 250, height: 250)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(radius: 5)
                            
                            Text("Taken on: \(patientManager.formattedDate(patient.photo.time))")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        HStack {
                            Text("Status:")
                                .font(.headline)
                            RoundedRectangle(cornerRadius: 5)
                                .fill(patientManager.colorForStatus(patient.status.dressingStatus))
                                .frame(width: 20, height: 20)
                        }
                        .padding(.vertical, 5)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Identified Issue: \(patientManager.descriptionForSymptom(patient.status.symptom))")
                            Text("Location: \(patient.location)")
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.white))
                        .cornerRadius(10)
                        
                        HStack(spacing: 15) {
                            Button("Recent Status") {}
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            
                            Button(action: {
                                print("Before Popup: \(patient.description)")
                                editingNotes = true
                            }, label: {
                                Text("Take Notes")
                            })
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                    
                }
                .background(patientManager.colorForStatus(patient.status.dressingStatus).opacity(0.3))
                .ignoresSafeArea(edges: .horizontal)
                .navigationTitle("Patient Status")
                EditingPopup(notesPopup: $editingNotes, nurseNotes: $nurseNotes)

            }

        /*
         }
        else {
            Text("No patient selected.")
                .foregroundColor(.gray)
                .navigationTitle("Patient Status")
        }
         */
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
