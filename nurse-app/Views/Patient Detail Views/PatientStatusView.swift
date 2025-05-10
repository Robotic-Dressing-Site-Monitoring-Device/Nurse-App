//
//  PatientStatusView.swift
//  nurse-app
//
//  Created by Chang, Daniel Soobin on 3/3/25.
//

import SwiftUI

struct PatientStatusView: View {
    @EnvironmentObject var patientManager: PatientManager
    @EnvironmentObject var statusManager: StatusManager
    @Binding var patient: Patient
    @State var nurseNotes: String = ""
    @State private var editingNotes: Bool = false

    var latestRemoteStatus: RemotePhoto? {
        statusManager.remotePhotos
            .filter { $0.patientName.lowercased() == "\(patient.firstName.lowercased()) \(patient.lastName.lowercased())" }
            .sorted(by: { $0.time > $1.time })
            .first
    }

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea(edges: .bottom)
            patientManager.colorForStatus(latestRemoteStatus != nil ? DressingStatus.fromRawFirestore(latestRemoteStatus!.status) : patient.status.dressingStatus)
                .opacity(0.2)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    if let latestPhoto = latestRemoteStatus {
                        VStack {
                            AsyncImage(url: URL(string: latestPhoto.imageURL)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 250, height: 250)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 250, height: 250)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .shadow(radius: 5)
                                case .failure:
                                    Color.gray
                                        .frame(width: 250, height: 250)
                                        .overlay(Text("Failed to load image"))
                                @unknown default:
                                    EmptyView()
                                }
                            }

                            Spacer().frame(height: 10)

                            Text("Taken on: \(patientManager.formattedDate(latestPhoto.time))")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    } else {
                        Text("No injury photo available")
                    }


                    Spacer().frame(height: 25)

                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Status:")
                                .font(.headline)
                                .foregroundColor(.black)
                            RoundedRectangle(cornerRadius: 5)
                                .fill(patientManager.colorForStatus(latestRemoteStatus != nil ? DressingStatus.fromRawFirestore(latestRemoteStatus!.status) : patient.status.dressingStatus))
                                .frame(width: 20, height: 20)
                        }
                        .padding(.vertical, 5)

                        VStack(alignment: .leading) {
                            Text("Identified Issues:")
                                .font(.headline)
                                .foregroundColor(.black)

                            if let latestPhoto = latestRemoteStatus {
                                ForEach(latestPhoto.issue, id: \.self) { issue in
                                    Text("• \(Symptom.fromRawFirestore(issue).displayName)")
                                        .foregroundColor(.black)
                                }
                            } else {
                                Text("• \(patientManager.descriptionForSymptom(patient.status.symptom))")
                                    .foregroundColor(.black)
                            }
                        }


                        HStack{
                            Text("Location: ")
                                .foregroundColor(.black)
                                .font(.headline)
                            Text("\(patient.location)")
                                .foregroundColor(.black)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.ButtonColor)
                    .cornerRadius(10)

                    Spacer().frame(height: 30)

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
                EditingPopup(notesPopup: $editingNotes, nurseNotes: $nurseNotes, patient: $patient)
            }
        }
        .onAppear {
            statusManager.fetchPhotos(for: patient)
        }

    }
}


// Custom popup for textfields
struct EditingPopup: View {
    @EnvironmentObject var patientManager: PatientManager
    @Binding var notesPopup: Bool
    @Binding var nurseNotes: String
    @Binding var patient: Patient

    var body: some View {
        if notesPopup {
            ZStack {
                Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
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
                                patientManager.recordNotes(for: patient, noteText: nurseNotes)
                                notesPopup = false
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



//#Preview {
//    PatientStatusView(patient: SampleData.samplePatientBinding[0])
//        .environmentObject(SampleData.sampleManager())
//        .environmentObject(StatusManager())
//}
