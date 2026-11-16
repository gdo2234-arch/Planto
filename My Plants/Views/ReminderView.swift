//
//  ReminderView.swift
//  My Plants
//
//  Created by Ghaida.
//

import SwiftUI

// 🍽️ صفحة النباتات (Main Page / Today Reminder)
struct ReminderView: View {
    @Environment(PlantsViewModel.self) private var viewModel // نجيب الطباخ
    @State private var showAddSheet = false // هل ورقة الاضافة مفتوحة؟
    @State private var plantToEdit: Plant? = nil // النبتة اللي نعدلها (لو فيها شي تطلع ورقة التعديل)

    // الجملة اللي فوق الشريط تتغير حسب كم نبتة انسقت
    private var progressMessage: String {
        if viewModel.wateredCount == 0 {
            return "Your plants are waiting for a sip 💦"
        } else {
            return "\(viewModel.wateredCount) of your plants feel loved today ✨"
        }
    }

    var body: some View {
        VStack(spacing: 0) {

            // 1. العنوان والخط
            HeaderView()

            // 2. المحتوى يتغير حسب الحالة
            if viewModel.plants.isEmpty {
                // حالة: حذف كل نباتاته
                Text("No reminders set yet..")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // بالنص

            } else if viewModel.allWatered {
                // حالة: سقى كل النباتات 🎉
                AllDoneView()

            } else {
                // حالة: فيه نباتات تنتظر السقي
                VStack(spacing: 12) {
                    Text(progressMessage) // الجملة
                    WaterProgressBar(progress: viewModel.progress) // الشريط المتحرك
                }
                .padding(.horizontal, 24) // يبعده عن الاطراف
                .padding(.top, 24)
                .padding(.bottom, 16)

                List { // القائمة: تعطينا خطوط فاصلة وسكرول تلقائي
                    ForEach(viewModel.plants) { plant in // لكل نبتة عند الطباخ، سوّ صف
                        PlantRowView(plant: plant) {
                            withAnimation { // حركة ناعمة للشريط والصف
                                viewModel.toggleWatered(plant) // ⭕ ↔ ✅
                            }
                        }
                        .contentShape(Rectangle()) // يخلي الصف كامل قابل للضغط (حتى الفراغات)
                        .onTapGesture {
                            plantToEdit = plant // ضغط على الصف ← تفتح ورقة التعديل
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) { // اسحب لليسار ← يطلع زر الحذف
                            Button(role: .destructive) {
                                withAnimation {
                                    viewModel.deletePlant(plant) // 🗑️
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .listStyle(.plain) // بدون صناديق رمادية، خلفية سادة
            }
        }
        // 3. زر + الطاير تحت يمين
        .overlay(alignment: .bottomTrailing) {
            AddButton {
                showAddSheet = true // يفتح ورقة الاضافة
            }
        }
        .sheet(isPresented: $showAddSheet) { // ورقة الاضافة
            SetReminderView()
        }
        .sheet(item: $plantToEdit) { plant in // ورقة التعديل: تطلع لما plantToEdit يصير فيها نبتة
            SetReminderView(plantToEdit: plant)
        }
    }
}

#Preview {
    ReminderView()
        .environment(PlantsViewModel.sample()) // طباخ تجريبي فيه نباتات
}
