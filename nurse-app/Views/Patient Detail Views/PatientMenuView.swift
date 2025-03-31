//
//  PatientStatusView.swift
//  nurse-app
//
//  Created by Chang, Daniel Soobin on 3/3/25.
//
/*
This view will act as a home page for each specific patient. Here, the user will be able to go through different tabs to access different information about the patient (i.e. patient information, dressing site status, patient notes, etc.)
 */
import SwiftUI

struct PatientMenuView: View {
    @EnvironmentObject var manager: PatientManager
    @Binding var patient: Patient
    var body: some View {
        NavigationStack {
            ZStack {
                TabView {
                    // View 1
                    NavigationView {
                        PatientHomeView(patient: $patient)
                    }
                    .tabItem {
                        Label("HomeView", systemImage: "house")
                    }
                    
                    // View 2
                    NavigationView {
                        PatientStatusView(patient: $patient)
                    }
                    .tabItem {
                        Label("StatusView", systemImage: "star")
                    }
                    
                    // View 3
                    NavigationView {
                        PatientSummaryView(patient: $patient)
                    }
                    .tabItem {
                        Label("SummaryView", systemImage: "pencil")
                    }
                    
                    // ...
                }
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }
}

#Preview {
    PatientMenuView(patient: SampleData.samplePatient)
        .environmentObject(SampleData.sampleManager())
}
