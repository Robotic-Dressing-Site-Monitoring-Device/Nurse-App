//
//  RecentStatusView.swift
//  nurse-app
//
//  Created by Chris Tseng on 4/5/25.
//

import SwiftUI

struct RecentStatusView: View {
    @Binding var patient: Patient
    @EnvironmentObject var patientManager: PatientManager

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()

                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(patient.injuryPhotos.filter { $0.patientID == patient.id }) { photo in
                            HStack(spacing: 0) {
                                Rectangle()
                                    .fill(patientManager.colorForStatus(patient.status.dressingStatus))
                                    .frame(width: 20)

                                VStack(alignment: .leading, spacing: 8) {
                                    
                                    HStack(alignment: .center, spacing: 12) {
                                        Image(uiImage: photo.image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 150, height: 150)
                                            .cornerRadius(8)

                                        VStack(alignment: .leading, spacing: 15) {
                                            
                                            Text("Status: \(patient.status.dressingStatus.rawValue)")
                                                .foregroundColor(patientManager.colorForStatus(patient.status.dressingStatus))

                                            Text("Symptom: \(patientManager.descriptionForSymptom(patient.status.symptom))")
                                                .font(.subheadline)
                                                .foregroundColor(.black)
                                            Text("Taken on: \(patientManager.formattedDate(photo.time))")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .center)
                                    }

                                  

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Notes")
                                            .font(.headline)
                                            .foregroundColor(.black)

                                        ScrollView(.vertical, showsIndicators: true) {
                                            Text(patient.description)
                                                .font(.body)
                                                .foregroundColor(.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        .frame(height: 80)
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                            }
                            .cornerRadius(12)
                            .shadow(radius: 2)
                        }
                    }
                    .padding()
                    .background(Color.white)
                }
            }
            .navigationTitle("Recent Status")
        }
    }
}



#Preview {
    RecentStatusView(patient: SampleData.samplePatientBinding[0])
        .environmentObject(SampleData.sampleManager())
}

