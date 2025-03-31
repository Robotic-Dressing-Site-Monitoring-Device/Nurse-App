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
        //if let patient = patientManager.currentPatient {
            ScrollView {
                VStack {
                    HStack {
                        // Patient Image
                        Image(uiImage: patient.photo.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 4))
                            .padding(.leading)
                        
                        // Patient vital info
                        VStack(alignment: .leading) {
                            Text("First Name: \(patient.firstName)")
                            Text("Last Name: \(patient.lastName)")
                            Text("Location: \(patient.location)")
                            
                            let status = patient.status.dressingStatus
                            Text("Status: \(status.rawValue)")
                                .foregroundColor(patientManager.colorForStatus(status))
                        }
                        
                    }
                    .ignoresSafeArea()
                    
                    // Nurse Notes (Summary)
                    Text(patient.description)
                        .padding()
                }
                
            }
            .ignoresSafeArea(edges: .horizontal)
        /*
         }
        else {
            Text("No patient selected")
        }
         */
        
    }
}

#Preview {
    PatientSummaryView(patient: SampleData.samplePatient)
        .environmentObject(SampleData.sampleManager())
}
