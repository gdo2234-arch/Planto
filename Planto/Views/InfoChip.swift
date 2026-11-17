//
//  InfoChip.swift
//  My Plants
//
//  Created by Ghaida.
//

import SwiftUI

// 🧩 التاق الصغير (مثل ☀️ Full Sun او 💧 20-50 ml)
struct InfoChip: View {
    let icon: String // اسم الايقونة
    let text: String // الكلام
    let color: Color // لون الكلام والايقونة

    var body: some View {
        Label(text, systemImage: icon) // ايقونة + كلام
            .font(.footnote) // خط صغير
            .foregroundStyle(color) // لون الكلام والايقونة (من assets، يتغير بين الدارك واللايت)
            .padding(.horizontal, 8) // مسافة يمين ويسار داخل التاق
            .padding(.vertical, 4) // مسافة فوق وتحت داخل التاق
            .background(Color(.secondarySystemBackground)) // خلفية رمادية: غامقة بالدارك وفاتحة باللايت
            .clipShape(RoundedRectangle(cornerRadius: 8)) // يقص الزوايا تصير دائرية شوي
    }
}

#Preview {
    InfoChip(icon: "sun.max", text: "Full Sun", color: .chipSun)
}
