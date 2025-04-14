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
                Color.white.ignoresSafeArea()

                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(patientManager.patientList) { patient in
                            NavigationLink(
                                destination: PatientMenuView(patient: .constant(patient))
                                    .onAppear {
                                        patientManager.setPatient(patient: .constant(patient))
                                    }
                            ) {
                                HStack(spacing: 0) {
                                    Rectangle()
                                        .fill(patientManager.colorForStatus(patient.status.dressingStatus))
                                        .frame(width: 20)

                                    PatientPreview(patient: .constant(patient))
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color.white)
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
            patientManager.loadPatientsFromFirestore()
        }
    }
}

//#Preview {
//    ContentView()
//        .environmentObject(SampleData.sampleManager())
//}
