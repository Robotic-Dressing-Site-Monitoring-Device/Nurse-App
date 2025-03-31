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
            List {
                ForEach($patientManager.patientList) { $patient in
                    VStack {
                        NavigationLink(destination: PatientMenuView(patient: $patient)
                            .onAppear {
                                patientManager.setPatient(patient: $patient)
                            }) {
                                PatientPreview(patient: $patient)
                        }
                            
                    }
                    .listRowBackground(patientManager.colorForStatus(patient.status.dressingStatus))
                    .padding()
                    
                }
                
            }
        }
        .onAppear {
            patientManager.currentPatient = nil
        }
    }
}


#Preview {
    ContentView()
        .environmentObject(PatientManager())
}
