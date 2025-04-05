//
//  ContentView.swift
//  nurse-app
//
//  Created by Chang, Daniel Soobin on 3/3/25.
//
/*
 This view is the main screen of the app. It should hold a list of all patients and a quick preview of their info. Clicking the preview should navigate to a view of their in-depth information
 
 Feature Suggestions:
    Search Bar
    Filter: Name, ID, Location
 */
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var patientManager: PatientManager

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                    .ignoresSafeArea()

                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(patientManager.patientList) { patient in
                            NavigationLink(destination: PatientMenuView(patient: .constant(patient))
                                .onAppear {
                                    patientManager.setPatient(patient: .constant(patient))
                                }) {
                                HStack(spacing: 0) {
                                    // Colored bar on the left (1/5th width)
                                    Rectangle()
                                        .fill(patientManager.colorForStatus(patient.status.dressingStatus))
                                        .frame(width: 20) // You can adjust the width or use geometry for dynamic width

                                    // Actual preview content
                                    PatientPreview(patient: .constant(patient))
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color.white) // Keep the background clean
                                }
                                .cornerRadius(12)
                                .shadow(radius: 2)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                }
            }
            .navigationTitle("Patient List")
        }
        .onAppear {
            patientManager.patientList = SampleData.samplePatients
            patientManager.currentPatient = Binding(get: { patientManager.patientList.first! }, set: { _ in })
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(SampleData.sampleManager())
}
