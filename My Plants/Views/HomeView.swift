//
//  HomeView.swift
//  My Plants
//
//  Created by Ghaida.
//

import SwiftUI

// 🍽️ شاشة المستخدم الجديد (Main Page - Empty State)
struct HomeView: View {
    // سبورة: هل ورقة Set Reminder مفتوحة؟ تبدا false يعني مقفولة (مثل مفتاح النور)
    @State private var showSetReminder = false

    var body: some View {
        VStack(spacing: 0) {

            // 1. العنوان والخط (قطعة مشتركة من مجلد Components)
            HeaderView()

            // 2. المحتوى
            VStack(spacing: 37) {

                Image("tree") // هنا ننادي الصوره من assets
                    .resizable() // يخلي الصورة تكبر وتصغر
                    .scaledToFit() // يحافظ على شكلها
                    .frame(width: 150) // عرض الصورة

                // نحط في ستاك ثاني عشان السبيسنغ تتغير هنا
                VStack(spacing: 25) {
                    Text("Start your plant journey!")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("Now all your plants will be in one place and we will help you take care of them :)🪴")
                        .font(.subheadline)
                        .foregroundStyle(.secondary) // لون رمادي
                        .multilineTextAlignment(.center) // يخلي الكلام بالنص
                        .padding(.horizontal, 40) // حواف النص او هوامشه
                }

                Button {
                    showSetReminder = true // يشغل المفتاح فتطلع الورقة
                } label: {
                    Text("Set Plant Reminder")
                        .foregroundStyle(.white) // هذا لون النص
                        .fontWeight(.medium)
                        .frame(width: 280, height: 42) // هذا لحجم الزر
                        .glassEffect(.regular.tint(.appGreen).interactive(), in: Capsule()) // تاثير القزاز: لونه اخضر ويتفاعل لما نضغطه وشكله كبسولة
                }
                .padding(.top, 50) // هذا يبعده عن النص اللي فوق
            }
            .padding(.bottom, 90) // هذا يخلي الفقرة مرتفعة
            .frame(maxWidth: .infinity, maxHeight: .infinity) // ياخذ باقي الشاشة تحت الخط
        }
        .sheet(isPresented: $showSetReminder) { // يراقب المفتاح، اول ما يصير true تطلع الورقة من تحت
            SetReminderView() // ورقة اضافة نبتة جديدة
        }
    }
}

#Preview {
    HomeView()
        .environment(PlantsViewModel()) // البريفيو يحتاج طباخ لان ورقة Set Reminder تستخدمه
}
