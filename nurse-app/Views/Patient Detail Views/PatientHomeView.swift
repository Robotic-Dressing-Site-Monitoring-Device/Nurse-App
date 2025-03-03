//
//  PatientHomeView.swift
//  nurse-app
//
//  Created by Chang, Daniel Soobin on 3/3/25.
//

import SwiftUI

struct PatientHomeView: View {
    @State var patient: Patient
    var body: some View {
        Text("Patient \(patient.id) Home View")
    }
}

#Preview {
    //let patient: Patient = Patient(id: 1, firstName: "john", lastName: "doe", location: "room 406")
    PatientHomeView(patient: Patient(id: 1, firstName: "john", lastName: "doe", location: "room 406"))
}
