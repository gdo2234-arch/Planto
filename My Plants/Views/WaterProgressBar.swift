//
//  WaterProgressBar.swift
//  My Plants
//
//  Created by Ghaida.
//

import SwiftUI

// 🧩 شريط التقدم المتحرك (Custom animated ProgressView)
struct WaterProgressBar: View {
    var progress: Double // من 0 (فاضي) الى 1 (مليان)

    var body: some View {
        GeometryReader { geo in // GeometryReader يقيس لنا عرض المكان المتاح (geo.size.width)
            ZStack(alignment: .leading) { // فوق بعض، ويبدون من اليسار
                Capsule() // الشريط الرمادي (الخلفية)
                    .fill(.gray.opacity(0.3))

                Capsule() // الشريط الاخضر (المليان)
                    .fill(.appGreen)
                    .frame(width: geo.size.width * progress) // عرضه = العرض كامل × النسبة
            }
        }
        .frame(height: 8) // سماكة الشريط
        .animation(.easeInOut(duration: 0.4), value: progress) // كل ما تتغير النسبة، يتحرك بنعومة
    }
}

#Preview {
    WaterProgressBar(progress: 0.6)
        .padding()
}
