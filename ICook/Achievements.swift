//
//  Achievements.swift
//  ICook
//
//  Created by Fabrizio Vollaro on 04/05/25.
//

import Foundation

struct Achievement: Identifiable, Codable {
    let id: Int
    let title: String
    let description: String
    let imageName: String
    var isUnlocked: Bool
}
