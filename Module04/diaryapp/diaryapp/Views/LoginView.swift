//
//  LoginView.swift
//  diaryapp
//
//  Created by Théo Ajavon on 17/04/2024.
//

import SwiftUI
import Auth0
import JWTDecode

struct LoginView: View {
    var body: some View {
        Text("Welcome to your Diary")
            .font(.title)
//        HStack {
//            Button("Login", action: self.login)
//                .padding()
//                .background(.green)
//                .foregroundStyle(.white)
//                .clipShape(RoundedRectangle(cornerRadius: 12))
//        }
        HStack {
            Button("Google", action: self.loginWithGoogle)
                .padding()
                .background(.green)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            Button("GitHub", action: self.loginWithGithub)
                .padding()
                .background(.green)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

extension LoginView {
    func decodeUserData(idToken: String) {
        guard let jwt = try? decode(jwt: idToken) else { return }
        print(jwt)
        //        print(jwt["email"].string)
    }
    
    func loginWithGithub() {
        Auth0
            .webAuth()
            .connection("github")
            .start { result in
                switch result {
                case .success(let credentials):
                    //                    print(credentials.idToken)
                    decodeUserData(idToken: credentials.idToken)
                case .failure(let error):
                    print("Failed with : \(error)")
                }
            }
    }
    func loginWithGoogle() {
        Auth0
            .webAuth()
            .connection("google-oauth2")
            .start { result in
                switch result {
                case .success(let credentials):
                    //                    print(credentials.idToken)
                    decodeUserData(idToken: credentials.idToken)
                case .failure(let error):
                    print("Failed with : \(error)")
                }
            }
    }
    
    func login() {
        Auth0
        .webAuth()
        .start { result in
            switch result {
            case .success(let credentials):
                //                    print(credentials.idToken)
                decodeUserData(idToken: credentials.idToken)
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
                    print("Logged out")
                case .failure(let error):
                    print("Failed with : \(error)")
                }
            }
    }
}

#Preview {
    LoginView()
}
