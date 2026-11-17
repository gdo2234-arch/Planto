//
//  HeaderView.swift
//  My Plants
//
//  Created by Ghaida.
//

import SwiftUI

// 🧩 قطعة مشتركة: العنوان My Plants والخط اللي تحته (نستخدمها في اكثر من شاشة بدل ما نكررها)
struct HeaderView: View {
    var body: some View {
        VStack(spacing: 0) {
            Text("My Plants 🌱")
                .font(.largeTitle) // اكبر حجم خط
                .fontWeight(.bold) // عريض
                .frame(maxWidth: .infinity, alignment: .leading) // يحط العنوان على اليسار
                .padding(.horizontal, 16) // يبعده عن طرف الشاشة
                .padding(.top, 8) // هذا الرقم يرفع او ينزل العنوان

            Rectangle() // الخط النحيف (مستطيل رفيع)
                .fill(.gray.opacity(0.4)) // لونه رمادي شفاف
                .frame(height: 1) // سماكته
                .padding(.top, 12) // المسافة بين العنوان والخط
        }
    }
}

#Preview {
    HeaderView()
}
