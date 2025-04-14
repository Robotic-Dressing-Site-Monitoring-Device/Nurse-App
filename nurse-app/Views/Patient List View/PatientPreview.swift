//
//  PatientPreview.swift
//  nurse-app
//
//  Created by Chang, Daniel Soobin on 3/3/25.
//

import SwiftUI

struct PatientPreview: View {
    @EnvironmentObject var manager: PatientManager
    @Binding var patient: Patient
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Name: \(patient.firstName) \(patient.lastName)")
                .font(.headline)
                .foregroundColor(Color.ListText)

            Text("Location: \(patient.location)")
                .font(.subheadline)
                .foregroundColor(Color.ListText)

            Text("Patient ID: \(patient.id)")
                .font(.subheadline)
                .foregroundColor(Color.ListText)

        }

        
    }
}

//#Preview {
//    PatientPreview(patient: SampleData.samplePatientBinding[0])
//        .environmentObject(PatientManager())
//}
