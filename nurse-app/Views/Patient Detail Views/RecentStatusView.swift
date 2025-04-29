//
//  RecentStatusView.swift
//  nurse-app
//
//  Created by Chris Tseng on 4/5/25.
//

import SwiftUI

struct RecentStatusView: View {
    @Binding var patient: Patient
    @EnvironmentObject var patientManager: PatientManager
    @EnvironmentObject var statusManager: StatusManager

    var filteredPhotos: [RemotePhoto] {
        statusManager.remotePhotos
            .filter { $0.patientName.lowercased() == "\(patient.firstName.lowercased()) \(patient.lastName.lowercased())" }
            .sorted(by: { $0.time > $1.time })
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()

                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredPhotos) { photo in
                            HStack(spacing: 0) {
                                Rectangle()
                                    .fill(patientManager.colorForStatus(DressingStatus.fromRawFirestore(photo.status)))
                                    .frame(width: 20)

                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(alignment: .center, spacing: 12) {
                                        AsyncImage(url: URL(string: photo.imageURL)) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                                    .frame(width: 150, height: 150)
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 150, height: 150)
                                                    .cornerRadius(8)
                                            case .failure:
                                                Color.gray
                                                    .frame(width: 150, height: 150)
                                                    .cornerRadius(8)
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }

                                        VStack(alignment: .leading, spacing: 15) {
                                            Text("Status: \(DressingStatus.fromRawFirestore(photo.status).displayName)")
                                                .foregroundColor(patientManager.colorForStatus(DressingStatus.fromRawFirestore(photo.status)))

                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("Symptoms:")
                                                    .font(.subheadline)
                                                    .foregroundColor(.black)

                                                if photo.issue.isEmpty {
                                                    Text("• None")
                                                        .foregroundColor(.black)
                                                } else {
                                                    ForEach(photo.issue, id: \.self) { issue in
                                                        Text("• \(Symptom.fromRawFirestore(issue).displayName)")
                                                            .foregroundColor(.black)
                                                    }
                                                }
                                            }


                                            Text("Taken on: \(patientManager.formattedDate(photo.time))")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .center)
                                    }

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Notes")
                                            .font(.headline)
                                            .foregroundColor(.black)

                                        ScrollView(.vertical, showsIndicators: true) {
                                            Text(patient.description)
                                                .font(.body)
                                                .foregroundColor(.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        .frame(height: 80)
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                            }
                            .cornerRadius(12)
                            .shadow(radius: 2)
                        }
                    }
                    .padding()
                    .background(Color.white)
                }
            }
            .navigationTitle("Recent Status")
            .onAppear {
                statusManager.fetchPhotos(for: patient)
            }
        }
    }
}

//#Preview {
//    RecentStatusView(patient: SampleData.samplePatientBinding[0])
//        .environmentObject(SampleData.sampleManager())
//        .environmentObject(StatusManager())
//}
