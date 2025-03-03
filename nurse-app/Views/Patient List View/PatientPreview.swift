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
        Text("Patient \(patient.id) Preview")
    }
}

#Preview {
    PatientPreview(patient: Patient(id: 1, firstName: "john", lastName: "doe", location: "room 406"))
        .environmentObject(PatientManager())
}
