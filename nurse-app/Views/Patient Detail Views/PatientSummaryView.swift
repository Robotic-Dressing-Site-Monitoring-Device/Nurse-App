//
//  PatientSummaryView.swift
//  nurse-app
//
//  Created by Chang, Daniel Soobin on 3/3/25.
//

import SwiftUI

struct PatientSummaryView: View {
    @EnvironmentObject var patientManager: PatientManager
    @Binding var patient: Patient

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()
                VStack(spacing: 24) {
                    Text("Information")
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    // Patient image + info
                    HStack(alignment: .top, spacing: 16) {
                        // Patient Image
                        Image(uiImage: patient.photo.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 130, height: 130)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 4))
                            .padding(.leading)
                        
                        // Divider
                        Divider()
                            .frame(height: 120)
                        
                        // Info section (just styling here)
                        ScrollView(.horizontal, showsIndicators: true) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Name: \(patient.firstName) \(patient.lastName)")
                                Text("Location: \(patient.location)")
                                Text("Status: \(patient.status.dressingStatus.rawValue)")
                                    .foregroundColor(patientManager.colorForStatus(patient.status.dressingStatus))
                            }
                            .foregroundColor(.black)
                            .padding()
                        }
                        .frame(width: 200, height: 100, alignment: .leading)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.ButtonColor)
                        .cornerRadius(12)
                        
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .frame(width: 400)
                    
                    Text("Notes")
                        .font(.headline)
                        .foregroundColor(.black)
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(patient.notes) { note in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(note.text)
                                        .foregroundColor(.black)
                                    Text("Time: \(patientManager.formattedDate(note.timestamp))")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .frame(width: 400, alignment: .leading)
                                .background(Color.ButtonColor)
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                    
                }
            }
            .navigationTitle("Patient Summary")
        }
    }
}

#Preview {
    PatientSummaryView(patient: SampleData.samplePatient)
        .environmentObject(SampleData.sampleManager())
}
