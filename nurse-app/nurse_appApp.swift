//
//  nurse_appApp.swift
//  nurse-app
//
//  Created by Chang, Daniel Soobin on 3/3/25.
//

import SwiftUI

@main
struct nurse_appApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(PatientManager())
        }
    }
}
