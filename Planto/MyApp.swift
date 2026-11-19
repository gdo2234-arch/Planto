//
//  MyApp.swift
//  My Plants
//
//  Created by Ghaida.
//kk

import SwiftUI

// باب البيت: من هنا يبدا التطبيق
@main
struct MyPlantsApp: App {
    // نوظف الطباخ (الـ ViewModel) مرة وحدة بس، و @State يخليه يبقى وما ينسونه
    @State private var viewModel = PlantsViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel) // نحط الطباخ في المطبخ المشترك عشان كل الشاشات تقدر تكلمه
        }
    }
}
