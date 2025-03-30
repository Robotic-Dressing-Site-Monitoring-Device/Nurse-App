//
//  PatientPreview.swift
//  nurse-app
//
//  Created by Chang, Daniel Soobin on 3/3/25.
//

import SwiftUI

struct PatientPreview: View {
    @EnvironmentObject var manager: PatientManager
    @State var patient: Patient
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Name: \(patient.firstName) \(patient.lastName)")
                .font(.headline)
            Text("Location: \(patient.location)")
                .font(.subheadline)
            Text("Patient ID: \(patient.id)")
                .font(.subheadline)
        }
        
    }
}

#Preview {
    PatientPreview(patient: SampleData.samplePatient)
        .environmentObject(PatientManager())
}
