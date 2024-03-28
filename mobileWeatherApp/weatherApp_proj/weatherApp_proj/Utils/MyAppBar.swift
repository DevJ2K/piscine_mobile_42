//
//  MyAppBar.swift
//  weatherApp_proj
//
//  Created by Théo Ajavon on 28/03/2024.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case currently = "sun.max"
    case today = "calendar.day.timeline.left"
    case weekly = "calendar"
}

struct MyAppBar: View {
    @Binding var selectedTab: Tab
    //    private var fillImage: String {
    //        selectedTab.rawValue + ".fill"
    //    }
    private var tabColor: Color {
        switch selectedTab {
        case .currently:
            return .blue
        case .today:
            return .green
        case .weekly:
            return .yellow
        }
    }
    
    private var tabName: String {
        switch selectedTab {
        case .currently:
            return "Currently"
        case .today:
            return "Today"
        case .weekly:
            return "Weekly"
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    if (selectedTab == tab) {
                        VStack(spacing: 6) {
                            Image(systemName: tab.rawValue)
                                .foregroundStyle(selectedTab == tab ? tabColor : .secondary)
                                .bold(selectedTab == tab)
                                .scaleEffect(selectedTab == tab ? 1.25 : 1.0)
                                .font(.system(size: 16))
                                .onTapGesture {
                                    withAnimation(.easeIn(duration: 0.2)) {
                                        selectedTab = tab
                                    }
                                }
                            
                            Text(tabName)
                                .foregroundStyle(tabColor)
                                .bold()
                                .font(.system(size: 12))
                        }
                    } else {
                        ZStack {
                            Image(systemName: tab.rawValue)
                                .foregroundStyle(selectedTab == tab ? tabColor : .secondary)
                                .bold(selectedTab == tab)
                                .scaleEffect(selectedTab == tab ? 1.25 : 1.0)
                                .font(.system(size: 16))
                                .onTapGesture {
//                                    withAnimation(.easeIn(duration: 0.2)) {
                                        selectedTab = tab
//                                    }
                                }
                            Text(tabName)
                                .opacity(0)
                                .foregroundStyle(tabColor)
                                .bold()
                                .font(.system(size: 12))
                            
                        }
                    }
                    
                    //                        .font(selectedTab == tab ? .headline : .subheadline)
                    Spacer()
                }
            }
        }
        .frame(width: nil, height: 60)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 32))
        .padding()
    }
}

#Preview {
    VStack {
        MyAppBar(selectedTab: .constant(.currently))
        MyAppBar(selectedTab: .constant(.today))
        MyAppBar(selectedTab: .constant(.weekly))
    }
}
