//
//  Plant.swift
//  My Plants
//
//  Created by Ghaida.
//

import Foundation // صندوق الادوات الاساسي (نصوص وارقام وتواريخ)، ما نحتاج SwiftUI لان هذا مو شاشة

// 🥕 الـ Model: قالب النبتة، يوصف وش المعلومات اللي عند كل نبتة (بيانات بس، ما يرسم ولا يطبخ)
// Identifiable يعني كل نبتة لها هوية خاصة فيها (عشان القائمة تفرق بين نبتتين نفس الاسم)
// Codable يعني نقدر نحول النبتة لبيانات ونحفظها في الجوال، ونرجعها بعدين
struct Plant: Identifiable, Codable {
    var id = UUID() // رقم هوية فريد يتولد تلقائي (var عشان الحفظ يقدر يرجعه مثل ما هو)
    var name: String // اسم النبتة (مثل Pothos)
    var room: String // الغرفة (مثل Bedroom)
    var light: String // الاضاءة (مثل Full Sun)
    var wateringDays: String // ايام السقي (مثل Every day)
    var water: String // كمية الموية (مثل 20-50 ml)
    var lastWateredDate: Date? = nil // اخر يوم انسقت فيه، و ? يعني ممكن تكون فاضية (nil) لو ما انسقت ابد

    // متى لازم تنسقى المرة الجاية؟ (اخر سقية + عدد ايام السقي)
    // لو ما انسقت ابد، يرجع nil يعني "لازم تنسقى الحين"
    var nextWateringDate: Date? {
        guard let last = lastWateredDate else { return nil } // guard يعني: اذا ما فيه تاريخ، اطلع من هنا وارجع nil
        let days = PlantOptions.days(for: wateringDays) // كم يوم بين كل سقية
        let startOfLastDay = Calendar.current.startOfDay(for: last) // بداية يوم السقية (الساعة 12 بالليل)
        return Calendar.current.date(byAdding: .day, value: days, to: startOfLastDay) // نزيد عليه الايام
    }

    // هل النبتة مسقية؟ (يعني لسا ما جا موعد سقيتها الجاية) ✅
    // مثال: نبتة "Once a week" سقيتها امس ← تبقى ✅ لين يمر اسبوع
    var isWatered: Bool {
        if let next = nextWateringDate { // اذا فيه موعد جاي
            return Date() < next // مسقية اذا الحين قبل الموعد
        } else {
            return false // ما انسقت ابد
        }
    }
}

// صندوق فيه كل الخيارات الثابتة اللي تطلع في القوائم (من التصميم)
// static يعني الخيارات تابعة للصندوق نفسه، نوصل لها كذا: PlantOptions.rooms
enum PlantOptions {
    static let rooms = ["Bedroom", "Living Room", "Kitchen", "Balcony", "Bathroom"] // الغرف
    static let lights = ["Full Sun", "Partial Sun", "Low Light"] // الاضاءة
    static let wateringDays = ["Every day", "Every 2 days", "Every 3 days", "Once a week", "Every 10 days", "Every 2 weeks"] // ايام السقي
    static let waterAmounts = ["20-50 ml", "50-100 ml", "100-200 ml", "200-300 ml"] // كمية الموية

    // يعطينا الايقونة المناسبة لكل نوع اضاءة
    static func lightIcon(for light: String) -> String {
        switch light { // switch مثل if بس لما عندنا خيارات كثيرة
        case "Partial Sun": return "sun.horizon" // شمس عند الافق
        case "Low Light": return "moon" // قمر
        default: return "sun.max" // اي شي ثاني: شمس كاملة
        }
    }

    // يحول ايام السقي لرقم (كم يوم بين كل سقية) عشان الاشعارات
    static func days(for wateringDays: String) -> Int {
        switch wateringDays {
        case "Every 2 days": return 2
        case "Every 3 days": return 3
        case "Once a week": return 7
        case "Every 10 days": return 10
        case "Every 2 weeks": return 14
        default: return 1 // Every day
        }
    }
}

// نباتات تجريبية للبريفيو بس (عشان نشوف شكل القائمة بدون ما نضيف بايدنا)
extension Plant { // extension يعني نضيف شي على قالب موجود
    static let samples: [Plant] = [
        Plant(name: "Monstera", room: "Kitchen", light: "Full Sun", wateringDays: "Every day", water: "20-50 ml"),
        Plant(name: "Pothos", room: "Bedroom", light: "Partial Sun", wateringDays: "Every 2 days", water: "20-50 ml", lastWateredDate: Date()),
        Plant(name: "Orchid", room: "Living Room", light: "Low Light", wateringDays: "Once a week", water: "50-100 ml"),
        Plant(name: "Spider", room: "Kitchen", light: "Full Sun", wateringDays: "Every 3 days", water: "20-50 ml")
    ]
}
