//
//  ContentView.swift
//  My Plants
//
//  Created by Ghaida.
//

import SwiftUI

// موظف الاستقبال: يقرر وش الشاشة اللي تطلع (مثل الفلو بالضبط)
struct ContentView: View {
    @Environment(PlantsViewModel.self) private var viewModel // نجيب الطباخ من المطبخ المشترك
    @Environment(\.scenePhase) private var scenePhase // حالة التطبيق: مفتوح قدام المستخدم ولا بالخلفية
    @State private var showSplash = true // هل السبلاش ظاهرة؟ تبدا true يعني ظاهرة

    var body: some View {
        ZStack { // ZStack يحط الاشياء فوق بعض (مثل الاوراق فوق بعض)، نستخدمه هنا عشان التبديل بين الشاشات يصير ناعم
            if showSplash {
                SplashView() // 1. اول شي: السبلاش
                    .transition(.opacity) // تختفي بشكل ناعم
            } else if viewModel.hasStarted == false {
                HomeView() // 2. سؤال الفلو: مستخدم جديد؟ نعم ← الشاشة الفاضية
            } else {
                ReminderView() // 3. لا ← صفحة النباتات
            }
        }
        .task { // task يشتغل مرة وحدة اول ما تطلع الشاشة
            try? await Task.sleep(for: .seconds(1.5)) // نستنى ثانية ونص (وقت السبلاش)
            withAnimation { // نغير بحركة ناعمة
                showSplash = false // نخفي السبلاش
            }
            await viewModel.requestNotificationPermission() // بعد السبلاش نطلب اذن الاشعارات، و await يعني نستنى المستخدم يجاوب
            viewModel.refreshReminders() // بعد الاذن، نجهز اشعارات كل النباتات
        }
        .onChange(of: scenePhase) { // كل ما تتغير حالة التطبيق
            if scenePhase == .active { // اذا رجع المستخدم للتطبيق
                viewModel.refreshReminders() // نحدث الاشعارات (يمكن جا يوم جديد)
            } else if scenePhase == .background { // اذا طلع المستخدم من التطبيق
                viewModel.refreshReminders() // نجهز الاشعارات من جديد، فتبدا الـ 10 ثواني من الحين
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(PlantsViewModel()) // البريفيو يحتاج طباخ خاص فيه عشان يشتغل
}
