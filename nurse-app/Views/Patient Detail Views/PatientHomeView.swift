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
        VStack(spacing: 20) {

            Image("Image")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                .shadow(radius: 5)
            
      
            VStack(alignment: .leading, spacing: 10) {
                Text("Name: \(patient.firstName) \(patient.lastName)")
                    .font(.headline)
                Text("Location: \(patient.location)")
                    .font(.subheadline)
                Text("Patient ID: \(patient.id)")
                    .font(.subheadline)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            HStack(){
                Button(action: {
                }) {
                    Text("Scan")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Button(action: {
                }) {
                    Text("Status")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            
        
        }
        .padding()
        .navigationTitle("Patient Home")
    }
}

#Preview {
    PatientHomeView(patient: Patient(id: 1, firstName: "John", lastName: "Doe", location: "Room 406"))
}
