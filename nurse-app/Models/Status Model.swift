//
//  Status Model.swift
//  nurse-app
//
//  Created by Chris Tseng on 4/13/25.
//
import Foundation

struct RemotePhoto: Identifiable {
    let id: String  
    let imageURL: String
    let issue: String
    let status: String
    let time: Date
    let patientName: String
}
