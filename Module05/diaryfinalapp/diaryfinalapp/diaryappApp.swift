//
//  diaryappApp.swift
//  diaryapp
//
//  Created by Théo Ajavon on 17/04/2024.
//

import SwiftUI
import FirebaseCore
import Auth0

@main
struct diaryappApp: App {
    @StateObject var dataManager = DataManager()
    
    init() {
        FirebaseApp.configure()
        
        // Without
        let credentialsManager = CredentialsManager(authentication: Auth0.authentication())
        
        // Face ID
//        var credentialsManager = CredentialsManager(authentication: Auth0.authentication())
//        credentialsManager.enableBiometrics(withTitle: "Unlock with Face ID")

        guard credentialsManager.hasValid() else {
            UserManager.shared.isAuthenticated = false
            print("The credentials manager isn't valid !")
            return
        }
        
        credentialsManager.credentials { result in
            switch result {
            case .success(let credentials):
                DispatchQueue.main.async {
                    UserManager.shared.user = User(from: credentials.idToken)
                    let _ = credentialsManager.store(credentials: credentials)
                    UserManager.shared.isAuthenticated = true
                }
                print("User data retrieved !")
            case .failure(let error):
                print("Failed with: \(error)")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataManager)
        }
    }
}
