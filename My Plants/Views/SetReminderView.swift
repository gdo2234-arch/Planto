//
//  SetReminderView.swift
//  My Plants
//
//  Created by Ghaida.
//

import SwiftUI

// 🍽️ ورقة اضافة وتعديل نبتة (نفس الشاشة للاثنين ♻️)
struct SetReminderView: View {
    @Environment(\.dismiss) private var dismiss // زر الاغلاق حق الورقة، لما نكتب dismiss() تنزل
    @Environment(PlantsViewModel.self) private var viewModel // نجيب الطباخ عشان نقوله يحفظ

    // لو جانا نبتة هنا = تعديل، لو فاضية (nil) = اضافة جديدة
    var plantToEdit: Plant? = nil

    // المسودة 📝: هنا الشاشة تتذكر وش كتب المستخدم ووش اختار (قبل ما يحفظ)
    @State private var plantName = "" // اسم النبتة، يبدا فاضي
    @State private var selectedRoom = "Bedroom" // الغرفة المختارة
    @State private var selectedLight = "Full Sun" // الاضاءة المختارة
    @State private var selectedWateringDays = "Every day" // ايام السقي المختارة
    @State private var selectedWater = "20-50 ml" // كمية الموية المختارة

    // هل الاسم فاضي؟ (عشان نطفي زر ✓ لو ما كتب اسم)
    private var isNameEmpty: Bool {
        plantName.trimmingCharacters(in: .whitespaces).isEmpty // نشيل المسافات ونشوف هل باقي شي
    }

    var body: some View {
        NavigationStack { // نحتاجه عشان يطلع الشريط اللي فوق (العنوان والازرار)
            Form { // الاستمارة: تعطينا الخلفية الرمادية والصفوف المرتبة

                // الصندوق الاول: اسم النبتة
                Section {
                    HStack { // جنب بعض
                        Text("Plant Name") // الكلمة اللي على اليسار
                        TextField("Pothos", text: $plantName) // خانة الكتابة، و $ يعني نعطيها القلم تكتب على السبورة
                            .tint(.appGreen) // يخلي مؤشر الكتابة اخضر
                    }
                }

                // الصندوق الثاني: الغرفة والاضاءة
                Section {
                    Picker(selection: $selectedRoom) { // قائمة اختيار، واللي ينختار ينكتب على السبورة
                        ForEach(PlantOptions.rooms, id: \.self) { option in // يمشي على الغرف وحدة وحدة
                            Text(option) // يكتب كل غرفة في القائمة
                        }
                    } label: { // شكل الصف
                        Label("Room", systemImage: "location") // ايقونة السهم + كلمة Room
                            .foregroundStyle(.primary) // يخلي الايقونة بيضا بالدارك وسودا باللايت
                    }

                    Picker(selection: $selectedLight) { // قائمة الاضاءة
                        ForEach(PlantOptions.lights, id: \.self) { option in
                            Label(option, systemImage: PlantOptions.lightIcon(for: option)) // كل خيار معه ايقونته
                        }
                    } label: {
                        Label("Light", systemImage: "sun.max")
                            .foregroundStyle(.primary)
                    }
                }

                // الصندوق الثالث: ايام السقي وكمية الموية
                Section {
                    Picker(selection: $selectedWateringDays) { // قائمة ايام السقي
                        ForEach(PlantOptions.wateringDays, id: \.self) { option in
                            Text(option)
                        }
                    } label: {
                        Label("Watering Days", systemImage: "drop")
                            .foregroundStyle(.primary)
                    }

                    Picker(selection: $selectedWater) { // قائمة كمية الموية
                        ForEach(PlantOptions.waterAmounts, id: \.self) { option in
                            Text(option)
                        }
                    } label: {
                        Label("Water", systemImage: "drop")
                            .foregroundStyle(.primary)
                    }
                }

                // الصندوق الرابع: زر الحذف (يطلع بس في التعديل)
                if let plant = plantToEdit {
                    Section {
                        Button(role: .destructive) { // destructive يخلي الكلام احمر (فعل خطير)
                            viewModel.deletePlant(plant) // نقول للطباخ يحذفها
                            dismiss() // نقفل الورقة
                        } label: {
                            Text("Delete Reminder")
                                .frame(maxWidth: .infinity) // ياخذ العرض كامل عشان يصير بالنص
                        }
                    }
                }
            }
            .navigationTitle("Set Reminder") // العنوان اللي فوق
            .navigationBarTitleDisplayMode(.inline) // يخلي العنوان صغير وبالنص
            .toolbar { // الشريط اللي فوق
                // زر X على اليسار (Cancel في الفلو)
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss() // يقفل الورقة بدون حفظ
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.primary)
                    }
                }

                // زر ✓ الاخضر على اليمين (Save في الفلو)
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        save() // نحفظ
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .buttonStyle(.glassProminent) // قزاز بارز وملون
                    .tint(.appGreen) // لون القزاز اخضر
                    .disabled(isNameEmpty) // ما يشتغل اذا ما كتب اسم
                }
            }
            .onAppear { // اول ما تطلع الورقة
                if let plant = plantToEdit { // اذا هي تعديل، نعبي المسودة بمعلومات النبتة القديمة
                    plantName = plant.name
                    selectedRoom = plant.room
                    selectedLight = plant.light
                    selectedWateringDays = plant.wateringDays
                    selectedWater = plant.water
                }
            }
        }
    }

    // وصفة الحفظ: ناخذ المسودة ونعطيها للطباخ
    private func save() {
        let name = plantName.trimmingCharacters(in: .whitespaces) // الاسم بدون مسافات زايدة

        if var plant = plantToEdit { // تعديل: نعدل البطاقة القديمة
            plant.name = name
            plant.room = selectedRoom
            plant.light = selectedLight
            plant.wateringDays = selectedWateringDays
            plant.water = selectedWater
            viewModel.updatePlant(plant)
        } else { // اضافة: نسوي نبتة جديدة
            viewModel.addPlant(name: name, room: selectedRoom, light: selectedLight, wateringDays: selectedWateringDays, water: selectedWater)
        }
        dismiss() // نقفل الورقة
    }
}

#Preview("Add") {
    SetReminderView()
        .environment(PlantsViewModel())
}

#Preview("Edit") {
    SetReminderView(plantToEdit: Plant.samples[0])
        .environment(PlantsViewModel())
}
