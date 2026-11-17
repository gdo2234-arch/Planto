//
//  AddButton.swift
//  My Plants
//
//  Created by Ghaida.
//

import SwiftUI

// 🧩 زر + الاخضر الطاير
struct AddButton: View {
    let action: () -> Void // وش يصير لما ينضغط (نعطيه وصفة من برا)

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus") // ايقونة +
                .font(.title2) // حجمها
                .fontWeight(.semibold) // سماكتها
                .foregroundStyle(.white) // لونها ابيض
                .frame(width: 56, height: 56) // حجم الزر
                .glassEffect(.regular.tint(.appGreen).interactive(), in: Circle()) // قزاز اخضر بشكل دائرة
        }
        .padding(.trailing, 24) // يبعده عن اليمين
        .padding(.bottom, 8) // يبعده عن تحت
    }
}

#Preview {
    AddButton { }
}
