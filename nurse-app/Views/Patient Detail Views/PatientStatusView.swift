//
//  PatientStatusView.swift
//  nurse-app
//
//  Created by Chang, Daniel Soobin on 3/3/25.
//


import SwiftUI

struct PatientStatusView: View {
    @EnvironmentObject var patientManager: PatientManager

    var body: some View {
        if let patient = patientManager.currentPatient {
            ScrollView {
                VStack(spacing: 20) {
                    VStack {
                        Image(uiImage: patient.photo.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(radius: 5)

                        Text("Taken on: \(formattedDate(patient.photo.time))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    HStack {
                        Text("Status:")
                            .font(.headline)
                        RoundedRectangle(cornerRadius: 5)
                            .fill(colorForStatus(patient.status.dressingStatus))
                            .frame(width: 20, height: 20)
                    }
                    .padding(.vertical, 5)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Identified Issue: \(descriptionForSymptom(patient.status.symptom))")
                        Text("Location: \(patient.location)")
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.white))
                    .cornerRadius(10)

                    HStack(spacing: 15) {
                        Button("Recent Status") {}
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(10)

                        Button("Documentation") {}
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            .background(colorForStatus(patient.status.dressingStatus).opacity(0.3))
                        .ignoresSafeArea()
                        .navigationTitle("Patient Status")
        } else {
            Text("No patient selected.")
                .foregroundColor(.gray)
                .navigationTitle("Patient Status")
        }
    }

    func colorForStatus(_ status: DressingStatus) -> Color {
        switch status {
        case .good:
            return .green
        case .possibleDanger:
            return .yellow
        case .urgent:
            return .red
        }
    }


    func descriptionForSymptom(_ symptom: Symptom) -> String {
        switch symptom {
        case .none:
            return "No symptoms"
        default:
            return symptom.rawValue
        }
    }


    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
}

#Preview {
    PatientStatusView()
        .environmentObject(SampleData.sampleManager())
}
