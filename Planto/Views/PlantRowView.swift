//
//  PlantRowView.swift
//  My Plants
//
//  Created by Ghaida.
//

import SwiftUI

// 🧩 صف النبتة الواحد في القائمة
struct PlantRowView: View {
    let plant: Plant // البطاقة كاملة بدل ما نعطيه كل معلومة لحالها
    let onToggle: () -> Void // وش يصير لما يضغط الدائرة (نعطيه وصفة من برا)

    var body: some View {
        HStack(spacing: 16) { // الدائرة والمعلومات جنب بعض

            // الدائرة ⭕ ✅
            Button {
                onToggle() // ننفذ الوصفة اللي جاتنا
            } label: {
                Image(systemName: plant.isWatered ? "checkmark.circle.fill" : "circle") // ? : يعني: اذا انسقت ✅ غير كذا ⭕
                    .font(.title2) // حجمها
                    .foregroundStyle(plant.isWatered ? Color.appGreen : Color.secondary) // اخضر لو انسقت، رمادي لو لا
            }
            .buttonStyle(.borderless) // عشان الضغط يكون على الدائرة بس، مو الصف كامل

            VStack(alignment: .leading, spacing: 6) { // المعلومات فوق بعض وتبدا من اليسار

                Label("in \(plant.room)", systemImage: "location") // ايقونة السهم + in واسم الغرفة
                    .font(.subheadline)
                    .foregroundStyle(.secondary) // رمادي

                Text(plant.name) // اسم النبتة
                    .font(.title) // خط كبير

                HStack(spacing: 8) { // التاقين جنب بعض
                    InfoChip(icon: PlantOptions.lightIcon(for: plant.light), text: plant.light, color: .chipSun) // تاق الاضاءة
                    InfoChip(icon: "drop", text: plant.water, color: .chipWater) // تاق الموية
                }
            }
            .opacity(plant.isWatered ? 0.4 : 1) // لو انسقت تصير باهتة
        }
        .padding(.vertical, 8) // مسافة فوق وتحت الصف
    }
}

#Preview {
    List {
        PlantRowView(plant: Plant.samples[0]) { }
        PlantRowView(plant: Plant.samples[1]) { }
    }
    .listStyle(.plain)
}
