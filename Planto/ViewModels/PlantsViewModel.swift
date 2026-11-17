//
//  PlantsViewModel.swift
//  My Plants
//
//  Created by Ghaida.
//

import Foundation // الادوات الاساسية
import Observation // اداة المراقبة: عشان الشاشات تعرف لما القائمة تتغير
import UserNotifications // ادوات الاشعارات من Apple

// 👨‍🍳 الـ ViewModel: الطباخ اللي يشيل قائمة النباتات ويشتغل عليها (يضيف ويعدل ويحذف ويسقي ويحفظ ويذكر بالاشعارات)
// @Observable يعني اي تغيير هنا، يدق جرس 🔔 والشاشات ترسم نفسها من جديد
// class مو struct: عشان كل الشاشات تكلم نفس الطباخ، مو نسخة منه
@Observable
class PlantsViewModel {

    var plants: [Plant] = [] // قائمة كل النباتات، تبدا فاضية
    var hasStarted = false // هل المستخدم ضاف اول نبتة؟ (جواب سؤال الفلو "New User?")

    private let plantsKey = "savedPlants" // اسم الدرج اللي نحفظ فيه النباتات في الجوال
    private let startedKey = "hasStarted" // اسم الدرج اللي نحفظ فيه هل بدا ولا لا

    // 🧪 للتجربة: خلها true عشان يجيك الاشعار بعد 10 ثواني بدل الساعة 9 الصبح (لا تنسى ترجعها false)
    private let isTesting = false
    private let reminderHour = 9 // ساعة التذكير: 9 الصبح

    // init يشتغل اول ما نوظف الطباخ
    init() {
        loadPlants() // نرجع النباتات المحفوظة من الجوال
        hasStarted = UserDefaults.standard.bool(forKey: startedKey) || !plants.isEmpty // بدا اذا محفوظ انه بدا، او عنده نباتات
    }

    // MARK: - الحسابات (للشريط والرسائل)

    // كم نبتة انسقت اليوم
    var wateredCount: Int {
        plants.filter { $0.isWatered }.count // filter يطلع بس اللي انسقت، و count يعدهم
    }

    // نسبة التقدم من 0 (ولا وحدة) الى 1 (كلهم انسقوا)
    var progress: Double {
        if plants.isEmpty { return 0 } // اذا ما فيه نباتات النسبة صفر
        return Double(wateredCount) / Double(plants.count) // اللي انسقت ÷ الكل
    }

    // هل كل النباتات انسقت؟ (عشان شاشة All Done)
    var allWatered: Bool {
        !plants.isEmpty && wateredCount == plants.count // فيه نباتات + كلهم انسقوا
    }

    // MARK: - الوصفات (الافعال)

    // ➕ اضافة نبتة جديدة
    func addPlant(name: String, room: String, light: String, wateringDays: String, water: String) {
        let newPlant = Plant(name: name, room: room, light: light, wateringDays: wateringDays, water: water) // نعبي بطاقة نبتة
        plants.append(newPlant) // نضيفها اخر القائمة
        hasStarted = true // صار عنده نباتات، ما عاد مستخدم جديد
        UserDefaults.standard.set(true, forKey: startedKey) // نحفظ انه بدا
        scheduleReminder(for: newPlant) // نجهز اشعار السقي حقها
        savePlants() // نحفظ في الجوال
    }

    // ✏️ تعديل نبتة موجودة
    func updatePlant(_ plant: Plant) {
        if let index = plants.firstIndex(where: { $0.id == plant.id }) { // ندور على مكان النبتة بالهوية حقتها
            plants[index] = plant // نبدلها بالنسخة الجديدة
            scheduleReminder(for: plant) // نجهز الاشعار من جديد (يمكن تغيرت ايام السقي)
            savePlants()
        }
    }

    // 🗑️ حذف نبتة
    func deletePlant(_ plant: Plant) {
        plants.removeAll { $0.id == plant.id } // نشيل النبتة اللي هويتها نفس هوية هذي
        cancelReminder(for: plant) // نلغي الاشعار حقها
        savePlants()
    }

    // 💧 سقي او الغاء السقي (الدائرة ⭕ ✅)
    func toggleWatered(_ plant: Plant) {
        if let index = plants.firstIndex(where: { $0.id == plant.id }) {
            if plants[index].isWatered {
                plants[index].lastWateredDate = nil // كانت مسقية ← نلغي (ترجع ⭕)
            } else {
                plants[index].lastWateredDate = Date() // ما كانت مسقية ← نحط تاريخ اليوم (تصير ✅)
            }
            scheduleReminder(for: plants[index]) // نحدث اشعارها: انسقت ← يسكت لين موعدها الجاي، ما انسقت ← يرجع يذكر
            savePlants()
        }
    }

    // 🔄 نحدث اشعارات كل النباتات (نناديها اول ما يفتح التطبيق، عشان لو جا يوم جديد)
    func refreshReminders() {
        for plant in plants { // لكل نبتة
            scheduleReminder(for: plant) // نجهز اشعارها حسب حالتها
        }
    }

    // MARK: - الاشعارات ⏰
    // الفكرة: كل نبتة لها منبه خاص فيها، يذكر بس لو النبتة ما انسقت

    // نطلب اذن من المستخدم (يطلع له سؤال: تسمح بالاشعارات؟)
    // async يعني هذي الوصفة تاخذ وقت (تستنى المستخدم يضغط سماح او رفض)
    func requestNotificationPermission() async {
        do {
            _ = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            print("Notification permission error: \(error)") // نطبع الخطا في الكونسول لو صار
        }
    }

    // نجهز منبه نبتة حسب حالتها (private يعني بس الطباخ يستخدمها من داخل)
    private func scheduleReminder(for plant: Plant) {
        cancelReminder(for: plant) // اول شي نلغي المنبه القديم عشان ما يتكرر

        // محتوى الاشعار (اللي يطلع على الشاشة)
        let content = UNMutableNotificationContent()
        content.title = "Planto" // العنوان
        content.body = "Hey! let's water your \(plant.name) 💧" // الكلام
        content.sound = .default // صوت الاشعار العادي

        let trigger: UNNotificationTrigger // متى يطلع الاشعار؟

        if plant.isWatered, let nextDate = plant.nextWateringDate {
            // ✅ الحالة 1: النبتة مسقية ← نسكت، ونذكر مرة وحدة يوم موعدها الجاي الساعة 9
            var components = Calendar.current.dateComponents([.year, .month, .day], from: nextDate) // ناخذ اليوم والشهر والسنة
            components.hour = reminderHour // ونحط الساعة 9
            trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false) // مرة وحدة بس
        } else if isTesting {
            // 🧪 تجربة: النبتة ما انسقت ← بعد 10 ثواني
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        } else {
            // ⭕ الحالة 2: النبتة ما انسقت ← نذكر كل يوم الساعة 9 لين يسقيها
            var components = DateComponents()
            components.hour = reminderHour
            trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true) // يتكرر كل يوم
        }

        // نربط الاشعار بهوية النبتة عشان كل نبتة لها منبه لحالها ونقدر نلغيه
        let request = UNNotificationRequest(identifier: plant.id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification error: \(error)")
            }
        }
    }

    // نلغي منبه نبتة (لما تنحذف او قبل ما نجهز واحد جديد)
    private func cancelReminder(for plant: Plant) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [plant.id.uuidString])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [plant.id.uuidString]) // ونشيله من الاشعارات اللي وصلت
    }

    // MARK: - الحفظ في الجوال

    // نحفظ القائمة في درج الجوال (UserDefaults) عشان ما تضيع لما يقفل التطبيق
    private func savePlants() {
        if let data = try? JSONEncoder().encode(plants) { // نحول القائمة لبيانات
            UserDefaults.standard.set(data, forKey: plantsKey) // نحطها في الدرج
        }
    }

    // نرجع القائمة من الدرج
    private func loadPlants() {
        if let data = UserDefaults.standard.data(forKey: plantsKey), // نفتح الدرج
           let saved = try? JSONDecoder().decode([Plant].self, from: data) { // نرجع البيانات نباتات
            plants = saved
        }
    }

    // طباخ تجريبي فيه نباتات جاهزة، للبريفيو بس
    static func sample() -> PlantsViewModel {
        let viewModel = PlantsViewModel()
        viewModel.plants = Plant.samples
        viewModel.hasStarted = true
        return viewModel
    }
}
