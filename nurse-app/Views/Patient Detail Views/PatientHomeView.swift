//
//  PatientHomeView.swift
//  nurse-app
//
//  Created by Chang, Daniel Soobin on 3/3/25.
//

import SwiftUI

struct PatientHomeView: View {
    @EnvironmentObject var patientManager: PatientManager
    @Binding var patient: Patient
    @State private var showCamera = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    Spacer().frame(height: 10)

                    Image(uiImage: patient.photo.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    
                    Spacer().frame(height: 50)

                    PatientPreview(patient: $patient)
                        .frame(width: 380, height: 150, alignment: .leading)
                        .padding()
                        .background(Color.ButtonColor)
                        .cornerRadius(10)
                    
                    Spacer().frame(height: 20)
                    
                    Button("Scan") {
                        showCamera = true
                    }
                    .frame(width: 380)
                    .padding()
                    .background(Color.ButtonColor)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .sheet(isPresented: $showCamera) {
                        CameraView { image in
                            // Save the captured image to patient (e.g. as latest profile or new injury photo)
                            patient.injuryPhotos.append(
                                Photo(
                                    id: patient.injuryPhotos.count + 1,
                                    patientID: patient.id,
                                    time: Date(),
                                    image: image
                                )
                            )
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    PatientHomeView(patient: SampleData.samplePatient)
        .environmentObject(SampleData.sampleManager())
}
