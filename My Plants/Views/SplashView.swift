//
//  SplashView.swift
//  My Plants
//
//  Created by Ghaida.
//

import SwiftUI

// 🍽️ شاشة السبلاش: اول شي يطلع لما يفتح التطبيق (ثانية ونص بس)
struct SplashView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image("tree") // صورة النبتة من assets
                .resizable()
                .scaledToFit()
                .frame(width: 120) // حجمها

            Text("My Plants 🌱")
                .font(.largeTitle)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // ياخذ الشاشة كاملة والمحتوى بالنص
    }
}

#Preview {
    SplashView()
}
