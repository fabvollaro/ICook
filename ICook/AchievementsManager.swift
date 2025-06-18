//
//  AchievementsManager.swift
//  ICook
//
//  Created by Fabrizio Vollaro on 04/05/25.
//

import Foundation

class AchievementManager: ObservableObject {
    static let shared = AchievementManager()
    
    @Published var achievements: [Achievement] = []
    
    private let storageKey = "savedAchievements"
    
    private init() {
        loadAchievements()
    }

    func unlockAchievement(id: Int) {
        if let index = achievements.firstIndex(where: { $0.id == id && !$0.isUnlocked }) {
            achievements[index].isUnlocked = true
            saveAchievements()
        }
    }
    
    private func loadAchievements() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([Achievement].self, from: data) {
            self.achievements = decoded
        } else {
            self.achievements = defaultAchievements()
        }
    }
    
    private func saveAchievements() {
        if let data = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func defaultAchievements() -> [Achievement] {
        return (1...12).map {
            Achievement(id: $0,
                        title: "Badge \($0)",
                        description: "Completa l'obiettivo \($0)",
                        imageName: "Badge\($0)",
                        isUnlocked: false)
        }
    }
}



//private func defaultAchievements() -> [Achievement] {
//    return [
//        Achievement(id: 1, title: "Memory Master", description: "Completa il gioco memory 5 volte", imageName: "Badge1", isUnlocked: false),
//        Achievement(id: 2, title: "Chef in Erba", description: "Cucina 10 ricette", imageName: "Badge2", isUnlocked: false),
//        Achievement(id: 3, title: "Costanza è tutto", description: "Apri l'app per 7 giorni consecutivi", imageName: "Badge3", isUnlocked: false),
//        // Aggiungi altri achievements qui
//    ]
//}

