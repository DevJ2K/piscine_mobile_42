//
//  DataManager.swift
//  diaryapp
//
//  Created by Théo Ajavon on 18/04/2024.
//
import Foundation
import SwiftUI

import FirebaseCore
import FirebaseFirestore

class DataManager: ObservableObject {
    @Published var diaryEntries: [DiaryEntry] = []
    
//    init() {
//        print("Init fetch entries !")
//        fetchEntries()
//    }
    
    func fetchEntries() {
        diaryEntries.removeAll()
        guard let user = UserManager.shared.user else { return }
        let db = Firestore.firestore()
        let ref = db.collection("notes")
            .whereField("usermail", isEqualTo: user.email)
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print("Error => \(error!.localizedDescription)")
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let auth_method = data["auth_method"] as? String ?? ""
                    let date = data["date"] as? Date ?? Date()
                    let icon = data["icon"] as? String ?? ""
                    let text = data["text"] as? String ?? ""
                    let title = data["title"] as? String ?? ""
                    let usermail = data["usermail"] as? String ?? ""
                    
                    let diaryEntry = DiaryEntry(id: document.documentID, auth_method: auth_method, date: date, icon: icon, text: text, title: title, usermail: usermail)
                    self.diaryEntries.append(diaryEntry)
                    
                }
            }
        }
    }
    
    func addEntry(title: String, icon: String, text: String) {
        guard let user = UserManager.shared.user else { return }
        let db = Firestore.firestore()
        let diaryEntry = DiaryEntry(id: "", auth_method: "any", date: Date(), icon: icon, text: text, title: title, usermail: user.email)
        let ref = db.collection("notes")
        ref.addDocument(data: [
            "auth_method": diaryEntry.auth_method,
            "date": diaryEntry.date,
            "icon": diaryEntry.icon,
            "text": diaryEntry.text,
            "title": diaryEntry.title,
            "usermail": diaryEntry.usermail
        ])
        fetchEntries()
//        diaryEntries.append(diaryEntry)
    }
    
    func deleteEntry(docId: String) {
        if (UserManager.shared.user == nil) { return }
        let db = Firestore.firestore()
        let ref = db.collection("notes")
        ref.document(docId).delete()
        fetchEntries()
    }
}
