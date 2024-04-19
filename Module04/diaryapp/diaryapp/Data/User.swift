//
//  User.swift
//  diaryapp
//
//  Created by Théo Ajavon on 17/04/2024.
//

import Foundation
import Auth0
import JWTDecode

// AuthManager to manage authentication state
class UserManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var user: User?
    
    static let shared = UserManager()
    
    func decodeUserData(idToken: String) {
        guard let jwt = try? decode(jwt: idToken) else { return }
        print(jwt)
        //        print(jwt["email"].string)
    }
    
    func login(dataManager: DataManager) {
        Auth0
        .webAuth()
        .start { result in
            switch result {
            case .success(let credentials):
                //                    print(credentials.idToken)
                self.isAuthenticated = true
                self.user = User(from: credentials.idToken)
                print(self.user ?? "User is still nil")
                dataManager.fetchEntries()
            case .failure(let error):
                print("Failed with : \(error)")
            }
        }
    }
    
    func logout() {
        Auth0
            .webAuth()
            .clearSession { result in
                switch result {
                case .success:
                    self.isAuthenticated = false
                    self.user = nil
                    print("Logged out")
                case .failure(let error):
                    print("Failed with : \(error)")
                }
            }
    }
}

struct User {
    let id: String
    let name: String
    let email: String
//    let emailVerified: String
    let picture: String
//    let updatedAt: String
}

extension User {
    init?(from idToken: String) {
        guard let jwt = try? decode(jwt: idToken),
              let id = jwt.subject,
              let name = jwt["name"].string,
              let email = jwt["email"].string,
//              let emailVerified = jwt["email_verified"].boolean,
              let picture = jwt["picture"].string
//              let updatedAt = jwt["updated_at"].string 
        else {
            return nil
        }
        self.id = id
        self.name = name
        self.email = email
//        self.emailVerified = String(describing: emailVerified)
        self.picture = picture
//        self.updatedAt = updatedAt
    }
}
