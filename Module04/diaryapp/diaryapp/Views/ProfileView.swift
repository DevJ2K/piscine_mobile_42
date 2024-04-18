//
//  ProfileView.swift
//  diaryapp
//
//  Created by Théo Ajavon on 17/04/2024.
//

import SwiftUI
import Foundation


func dateToString(date: Date, format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    let dateString = dateFormatter.string(from: date)
    return dateString
    //    var convertFormat = ""
    //
    //    // "16 March 2023"
    //    dateFormatter.dateFormat = "dd MMMM yyyy"
    //    let dateString1 = dateFormatter.string(from: Date())
    //
    //    // "Thursday, March 16, 2023"
    //    dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
    //    let dateString2 = dateFormatter.string(from: Date())
    //
    //    print(dateString1) // Output: 16 March 2023
    //    print(dateString2) // Output: Thursday, March 16, 2023
    
}

struct AddEntryView: View {
    @EnvironmentObject var dataManager: DataManager
    @Binding var isPresented: Bool
    
    @State private var title: String = ""
    @State private var text: String = ""
    @State private var selectedIcon: String = "happy"
    @State private var showingAlert: Bool = false
    @FocusState private var descFocus
    @FocusState private var titleFocus
    var body: some View {
        //        NavigationView {
        
        VStack {
            Text("Add an entry")
                .font(Font.custom("SignPainter", size: 48))
            //                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            Menu {
                Button {
                    selectedIcon = "happy"
                } label: {
                    HStack {
                        Text("Happy")
                        Image("happy")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                }
                Button {
                    selectedIcon = "meh"
                } label: {
                    HStack {
                        Text("Not good")
                        Image("meh")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                }
                Button {
                    selectedIcon = "sad"
                } label: {
                    HStack {
                        Text("Sad")
                        Image("sad")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                }
            } label: {
                Image(selectedIcon)
                    .resizable()
                    .frame(width: 32, height: 32)
            }
            
            TextField("Title", text: $title)
                .focused($titleFocus)
                .autocorrectionDisabled(true)
                .onChange(of: title) { newValue in
                    if (newValue.count > 40) {
                        let _ = title.popLast()
                    }
                }
                .frame(height: 58)
                .textFieldStyle(PlainTextFieldStyle())
                .padding([.horizontal], 12)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 16).stroke(Color.gray)
                })
                .font(Font.custom("SignPainter", size: 24))
                .padding()
            
            TextField("Text", text: $text, axis: .vertical)
                .focused($descFocus)
                .onChange(of: text) { newValue in
                    if (newValue.count > 2000 || newValue.last == "\n") {
                        let _ = text.popLast()
                        self.descFocus = false
                    }
                }
            //                    .lineLimit(8)
                .frame(height: 200)
                .textFieldStyle(PlainTextFieldStyle())
                .padding([.horizontal], 12)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 16).stroke(Color.gray)
                        .background(.black.opacity(0))
                        .onTapGesture {
                            self.descFocus = true
                        }
                })
                .font(Font.custom("SignPainter", size: 24))
                .padding()
            
            Button(action: {
                if (title.isEmpty || text.isEmpty) {
                    self.showingAlert = true
                    return
                }
                titleFocus = false
                descFocus = false
                isPresented = false
                dataManager.addEntry(title: title, icon: selectedIcon, text: text)
            }, label: {
                Text("Add")
                    .frame(maxWidth: .infinity)
                    .font(Font.custom("SignPainter", size: 28))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.purple)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                    .alert("Please complete all fields.", isPresented: $showingAlert) {
                        Button("OK", role: .cancel) {}
                    }
            })
        }
        //        }
    }
    
}

struct DeleteEntryView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) var dismiss
    var entry: DiaryEntry
    //    @Binding var isPresented: Bool
    var body: some View {
        //        ScrollView {
        Text(dateToString(date: entry.date, format: "EEEE, MMMM dd, yyyy"))
            .font(Font.custom("SignPainter", size: 42))
            .frame(height: 100)
        Rectangle()
            .fill(.black)
            .frame(width: 250, height: 2)
            .padding(.horizontal)
        Text(entry.title)
            .font(Font.custom("SignPainter", size: 36))
        Rectangle()
            .fill(.black)
            .frame(width: 250, height: 2)
            .padding(.horizontal)
        HStack {
            Text("My feeling : ")
                .font(Font.custom("SignPainter", size: 36))
            Image(entry.icon)
                .resizable()
                .frame(width: 32, height: 32)
        }
        Rectangle()
            .fill(.black)
            .frame(width: 250, height: 2)
            .padding(.horizontal)
        ScrollView {
            Text(entry.text)
                .font(Font.custom("SignPainter", size: 28))
        }
        
        Button(action: {
            self.dismiss()
            //            print("Delete this entry")
            dataManager.deleteEntry(docId: entry.id)
        }, label: {
            Text("Delete this entry")
                .frame(maxWidth: .infinity)
                .font(Font.custom("SignPainter", size: 28))
                .padding()
                .frame(maxWidth: .infinity)
                .background(.red)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
            //                .alert("Please complete all fields.", isPresented: $showingAlert) {
            //                    Button("OK", role: .cancel) {}
            //                }
        })
    }
    //    }
}

struct ProfileView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showNewEntryModal: Bool = false
    //    @State private var showDeleteEntryModal: Bool = true
    
    
    //    let testEntry: [DiaryEntry] = [
    //        DiaryEntry(id: "1", auth_method: "github", date: Date(), icon: "happy", text: "Coool journey", title: "Title 1", usermail: "j2k@gmail.com"),
    //        DiaryEntry(id: "2", auth_method: "github", date: Date(), icon: "meh", text: "Coool journey", title: "Title 1", usermail: "j2k@gmail.com"),
    //        DiaryEntry(id: "3", auth_method: "github", date: Date(), icon: "meh", text: "Coool journey", title: "Title 1", usermail: "j2k@gmail.com"),
    //        DiaryEntry(id: "4", auth_method: "github", date: Date(), icon: "sad", text: "Coool journey", title: "Title 1", usermail: "j2k@gmail.com"),
    //        DiaryEntry(id: "5", auth_method: "github", date: Date(), icon: "happy", text: "Coool journey", title: "Title 1", usermail: "j2k@gmail.com"),
    //        DiaryEntry(id: "6", auth_method: "github", date: Date(), icon: "meh", text: "Coool journey", title: "Title 1", usermail: "j2k@gmail.com"),
    //        DiaryEntry(id: "7", auth_method: "github", date: Date(), icon: "sad", text: "Coool journey", title: "Title 1", usermail: "j2k@gmail.com"),
    //    ]
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Text("Your last diary entries")
                        .font(Font.custom("SignPainter", size: 42))
                        .foregroundStyle(.white)
                        .padding()
                        .bold()
                    ScrollView {
                        ForEach(dataManager.diaryEntries, id: \.id) { listEntry in
                            //                        ForEach(testEntry, id: \.id) { listEntry in
                            NavigationLink {
                                DeleteEntryView(entry: listEntry)
                                    .environmentObject(dataManager)
                            } label: {
                                
                                HStack {
                                    VStack {
                                        Text(dateToString(date: listEntry.date, format: "dd"))
                                            .font(Font.custom("SignPainter", size: 22))
                                            .foregroundStyle(.black)
                                        Text(dateToString(date: listEntry.date, format: "MMMM"))
                                            .font(Font.custom("SignPainter", size: 22))
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
                                        .frame(width: 1)
                                        .padding(.horizontal)
                                    Text(listEntry.title)
                                        .font(Font.custom("SignPainter", size: 32))
                                        .foregroundStyle(.black)
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                }
                .padding()
                .frame(height: 400)
                .background(.purple.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                Spacer()
                Button("New diary entry", action: {
                    self.showNewEntryModal = true
                })
                .font(Font.custom("SignPainter", size: 28))
                .padding()
                .background(.purple)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding()
                .sheet(isPresented: self.$showNewEntryModal) {
                    AddEntryView(isPresented: $showNewEntryModal)
                        .environmentObject(dataManager)
                    //                        .presentationDetents([.large])
                }
            }
            //            List(testEntry, id: \.id) { listEntry in
            ////            List(dataManager.diaryEntries, id: \.id) { listEntry in
            //                HStack {
            //                    HStack {
            //                        Text(listEntry.date?.description ?? "")
            //                        Text(listEntry.icon)
            //                    }
            //                    Divider()
            //                        .padding(.vertical)
            //                    Text(listEntry.title)
            //                }
            //            }
            //            VStack {
            //
            //                Spacer()
            //                HStack {
            //                    Spacer()
            //                }
            //                VStack {
            //                    Text("You are logged !")
            //                        .font(Font.custom("SignPainter", size: 42))
            //
            //                        .padding()
            //                    Button("Logout", action: UserManager.shared.logout)
            //                        .font(Font.custom("SignPainter", size: 28))
            //                        .padding()
            //                        .background(.red)
            //                        .foregroundStyle(.white)
            //                        .clipShape(RoundedRectangle(cornerRadius: 16))
            //                }
            //                .padding()
            //                Spacer()
            //
            //            }
            .navigationTitle("Profile")
            .toolbar {
                Button(action: UserManager.shared.logout, label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                })
                //                        .font(Font.custom("SignPainter", size: 28))
                //                        .padding()
                //                        .background(.red)
                //                        .foregroundStyle(.white)
                //                        .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        
    }
}

#Preview {
    //    ContentView()
        MainView()
    //    AddEntryView()
//            ProfileView()
//    DeleteEntryView(entry: DiaryEntry(id: "1", auth_method: "github", date: Date(), icon: "happy", text: "Nam quis nulla. Integer malesuada. In in enim a arcu imperdiet malesuada. Sed vel lectus. Donec odio urna, tempus molestie, porttitor ut, iaculis quis, sem. Phasellus rhoncus. Aenean id metus id velit ullamcorper pulvinar. Vestibulum fermentum tortor id mi. Pellentesque ipsum. Nulla non arcu lacinia neque faucibus fringilla. Nulla non lectus sed nisl molestie malesuada. Proin in tellus sit amet nibh dignissim sagittis. Vivamus luctus egestas leo. Maecenas sollicitudin. Nullam rhoncus aliquam metus. Etiam egestas wisi a erat.Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Nullam feugiat, turpis at pulvinar vulputate, erat libero tristique tellus, nec bibendum odio risus sit amet ante. Aliquam erat volutpat. Nunc auctor. Mauris pretium quam et urna. Fusce nibh. Duis risus. Curabitur sagittis hendrerit ante. Aliquam erat volutpat. Vestibulum erat nulla, ullamcorper nec, rutrum non, nonummy ac, erat. Duis condimentum augue id magna semper rutrum. Nullam justo enim, consectetuer nec, ullamcorper ac, vestibulum in, elit. Proin pede metus, vulputate nec, fermentum fringilla, vehicula vitae, justo. Fusce consectetuer risus a nunc. Aliquam ornare wisi eu metus. Integer pellentesque quam vel velit. Duis pulvinar. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Morbi gravida libero nec velit. Morbi scelerisque luctus velit. Etiam dui sem, fermentum vitae, sagittis id, malesuada in, quam. Proin mattis lacinia justo. Vestibulum facilisis auctor urna. Aliquam in lorem sit amet leo accumsan lacinia. Integer rutrum, orci vestibulum ullamcorper ultricies, lacus quam ultricies odio, vitae placerat pede sem sit amet enim. Phasellus et lorem id felis nonummy placerat. Fusce dui leo, imperdiet in, aliquam sit amet, feugiat eu, orci. Aenean vel massa quis mauris vehicula lacinia. Quisque tincidunt scelerisque libero. Maecenas libero. Etiam dictum tincidunt diam. Donec ipsum massa, ullamcorper in, auctor et, scelerisque sed, est. Suspendisse nisl. Sed convallis magna eu sem. Cras pede libero, dapibus nec, pretium sit amet, tempor quis, urna. Etiam posuere quam ac quam. Maecenas aliquet accumsan leo. Nullam dapibus fermentum ipsum. Etiam quis quam. Integer lacinia. Nulla est. Nulla turpis magna, cursus sit amet, suscipit a, interdum id, felis. Integer vulputate sem a nibh rutrum consequat. Maecenas lorem. Pellentesque pretium lectus id turpis. Etiam sapien elit, consequat eget, tristique non, venenatis quis, ante. Fusce wisi. Phasellus faucibus molestie nisl. Fusce eget urna. Curabitur vitae diam non enim vestibulum interdum. Nulla quis diam. Ut tempus purus at lorem. In sem justo, commodo ut, suscipit at, pharetra vitae, orci. Duis sapien nunc, commodo et, interdum suscipit, sollicitudin et, dolor. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Aliquam id dolor. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Mauris dictum facilisis augue. Fusce tellus. Pellentesque arcu. Maecenas fermentum, sem in pharetra pellentesque, velit turpis volutpat ante, in pharetra metus odio a lectus. Sed elit dui, pellentesque a, faucibus vel, interdum nec, diam. Mauris dolor felis, sagittis at, luctus sed, aliquam non, tellus. Etiam ligula pede, sagittis quis, interdum ultricies, scelerisque eu, urna. Nullam at arcu a est sollicitudin euismod. Praesent dapibus. Duis bibendum, lectus ut viverra rhoncus, dolor nunc faucibus libero, eget facilisis enim ipsum id lacus. Nam sed tellus id magna elementum tincidunt.Morbi a metus. Phasellus enim erat, vestibulum vel, aliquam a, posuere eu, velit. Nullam sapien sem, ornare ac, nonummy non, lobortis a, enim. Nunc tincidunt ante vitae massa. Duis ante orci, molestie vitae, vehicula venenatis, tincidunt ac, pede. Nulla accumsan, elit sit amet varius semper, nulla mauris mollis quam, tempor suscipit diam nulla vel leo. Etiam commodo dui eget wisi. Donec iaculis gravida nulla. Donec quis nibh at felis congue commodo", title: "Title 1", usermail: "j2k@gmail.com"))
        .environmentObject(DataManager())
}
