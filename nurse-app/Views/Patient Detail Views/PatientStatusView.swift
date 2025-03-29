//
//  PatientStatusView.swift
//  nurse-app
//
//  Created by Chang, Daniel Soobin on 3/3/25.
//

import SwiftUI

struct PatientStatusView: View {
    @State private var latestImage: String = "Injured area"
    @State private var timeTaken: String = "2025-03-23 17:00"
    @State private var statusColor: Color = .red
    @State private var identifiedIssue: String = "Possible infection at wound site"
    @State private var issueLocation: String = "Left leg"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack {
                    Image(latestImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 5)
                    
                    Text("Taken on: \(timeTaken)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
              
                HStack {
                    Text("Status:")
                        .font(.headline)
                    RoundedRectangle(cornerRadius: 5)
                        .fill(statusColor)
                        .frame(width: 20, height: 20)
                }
                .padding(.vertical, 5)
                
        
                VStack(alignment: .leading, spacing: 8) {
                    Text("Identified Issue: \(identifiedIssue)")
                    Text("Location: \(issueLocation)")
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                HStack(spacing: 15) {
                    Button(action: {
                    }) {
                        Text("Recent Status")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                    }) {
                        Text("Documentation")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Patient Status")
    }
}

#Preview {
    PatientStatusView()
}

//Whole background
