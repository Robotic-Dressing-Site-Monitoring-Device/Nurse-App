//
//  NotificationDetailView.swift
//  nurse-app
//
//  Created by Chris Tseng on 3/3/25.
//

import SwiftUI

struct NotificationDetailView: View {
    @EnvironmentObject var manager: PatientManager
    @State var patient: Patient
    var body: some View {
        NavigationStack {
            VStack (){
                NavigationLink(destination: PatientPreview(patient: patient)) {
                    Text("Patient Preview")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                }
                .padding(.top, 20)
                Spacer()
                
                Text("Notification Detail View")
                Spacer()
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }
}



/*#Preview {
     NotificationDetailView(patient: SampleData.samplePatient)))
        .environmentObject(SampleData.sampleManager())
}*/

