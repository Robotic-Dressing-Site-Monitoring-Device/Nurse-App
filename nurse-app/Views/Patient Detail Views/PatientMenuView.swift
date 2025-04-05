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
                    PatientStatusView(patient: $patient)
                        .tabItem {
                            Label("StatusView", systemImage: "star")
                        }
                        .preferredColorScheme(.light)

                    PatientHomeView(patient: $patient)
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                Text("\(patient.firstName) \(patient.lastName)'s Information")
                                    .font(.headline)
                            }
                        }
                        .preferredColorScheme(.light)


                    PatientSummaryView(patient: $patient)
                        .tabItem {
                            Label("SummaryView", systemImage: "pencil")
                        }
                        .preferredColorScheme(.light)
                }

                .tint(Color.MenuButton)
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }
}

#Preview {
    PatientMenuView(patient: SampleData.samplePatientBinding[0])
        .environmentObject(SampleData.sampleManager())
}
