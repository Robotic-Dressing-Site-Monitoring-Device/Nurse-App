//
//  PatientHomeView.swift
//  nurse-app
//
//  Created by Chang, Daniel Soobin on 3/3/25.
//

import SwiftUI

struct PatientHomeView: View {
    @EnvironmentObject var patientManager: PatientManager

    var body: some View {
        if let patient = patientManager.currentPatient {
            VStack(spacing: 20) {
                Image(uiImage: patient.photo.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 4))
                    

                PatientPreview(patient: patient)
                
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(10)

                HStack {
                    Button("Scan") { }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)

                    Button("Status") { }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Patient Home")
        } else {
            Text("No patient selected.")
                .foregroundColor(.gray)
                .navigationTitle("Patient Home")
        }
    }
}

#Preview {
    PatientHomeView()
        .environmentObject(SampleData.sampleManager())
}
