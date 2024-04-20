//
//  CalendarView.swift
//  diaryapp
//
//  Created by Théo Ajavon on 18/04/2024.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var date = Date()
    
        let testEntry: [DiaryEntry] = [
            DiaryEntry(id: "1", auth_method: "github", date: Date(), icon: "happy", text: "Coool journey", title: "Title 1", usermail: "j2k@gmail.com"),
            DiaryEntry(id: "2", auth_method: "github", date: Date(), icon: "meh", text: "Coool journey", title: "Title 1", usermail: "j2k@gmail.com"),
            DiaryEntry(id: "3", auth_method: "github", date: Date(), icon: "meh", text: "Coool journey", title: "Title 1", usermail: "j2k@gmail.com"),
            DiaryEntry(id: "4", auth_method: "github", date: Date(), icon: "sad", text: "Coool journey", title: "Title 1", usermail: "j2k@gmail.com"),
            DiaryEntry(id: "5", auth_method: "github", date: Date(), icon: "happy", text: "Coool journey", title: "Title 1", usermail: "j2k@gmail.com"),
            DiaryEntry(id: "6", auth_method: "github", date: Date(), icon: "meh", text: "Coool journey", title: "Title 1", usermail: "j2k@gmail.com"),
            DiaryEntry(id: "7", auth_method: "github", date: Date(), icon: "sad", text: "Coool journey", title: "Title 1", usermail: "j2k@gmail.com"),
        ]
    private let calendar = Calendar.current
    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "Start Date",
                    selection: $date,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                
                ScrollView {
                    ForEach(dataManager.diaryEntries.filter { calendar.isDate($0.date, equalTo: date, toGranularity: .day) }, id: \.id) { listEntry in
                        //                        ForEach(testEntry, id: \.id) { listEntry in
                        NavigationLink {
                            DeleteEntryView(entry: listEntry)
                                .environmentObject(dataManager)
                        } label: {
                            
                            HStack {
                                VStack {
                                    Text(dateToString(date: listEntry.date, format: "dd"))
                                        .font(Font.custom("SignPainter", size: 14))
                                        .foregroundStyle(.black)
                                    Text(dateToString(date: listEntry.date, format: "MMMM"))
                                        .font(Font.custom("SignPainter", size: 14))
                                        .foregroundStyle(.black)
                                    Text(dateToString(date: listEntry.date, format: "YYYY"))
                                        .font(Font.custom("SignPainter", size: 14))
                                        .foregroundStyle(.black)
                                        .opacity(0.3)
                                }
                                .padding(.horizontal)
                                
                                Image(listEntry.icon)
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                Rectangle()
                                    .fill(.black.opacity(0.4))
                                    .frame(width: 1, height: .infinity)
                                    .padding(.horizontal)
                                Text(listEntry.title)
                                    .font(Font.custom("SignPainter", size: 22))
                                    .foregroundStyle(.black)
                                Spacer()
                            }
                            .padding(.vertical)
                            .frame(height: 100)
                            .frame(maxWidth: .infinity)
                            
                            .padding(.horizontal)
                            .background(Rectangle()
                                .fill(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(color: .black, radius: 2, x: 1, y: 1)
                            )
                            .padding(.horizontal)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(DataManager())
}
