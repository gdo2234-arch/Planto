//
//  AllDoneView.swift
//  My Plants
//
//  Created by Ghaida.
//

import SwiftUI

// 🍽️ تطلع لما يسقي كل النباتات (All Reminders Completed)
struct AllDoneView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image("treeWink") // صورة النبتة اللي تغمز 😉 من assets
                .resizable()
                .scaledToFit()
                .frame(width: 140)
                .padding(30) // مسافة بين الصورة والدائرة
                .background(Circle().fill(Color(.secondarySystemBackground))) // دائرة رمادية ورا الصورة

            VStack(spacing: 8) {
                Text("All Done! 🎉")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("All Reminders Completed")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.bottom, 90) // يرفع المحتوى شوي
        .frame(maxWidth: .infinity, maxHeight: .infinity) // ياخذ باقي الشاشة
    }
}

#Preview {
    AllDoneView()
}
