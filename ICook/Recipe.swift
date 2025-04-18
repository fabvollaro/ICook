//
//  Recipe.swift
//  ICook
//
//  Created by Fabrizio Vollaro on 11/12/24.
//

import SwiftUI

struct Recipe: Identifiable, Codable, Equatable { // Aggiunto Codable
    let id: UUID
    var name: String
    var ingredients: String
    var procedure: String
    var imageData: Data? // Modifica: Salvare l'immagine come Data per renderla Codable

    init(id: UUID = UUID(), name: String, ingredients: String, procedure: String, image: UIImage? = nil) {
        self.id = id
        self.name = name
        self.ingredients = ingredients
        self.procedure = procedure
        self.imageData = image?.jpegData(compressionQuality: 1.0) // Converti UIImage in Data
    }

    var image: UIImage? {
        // Converti Data in UIImage quando necessario
        if let imageData {
            return UIImage(data: imageData)
        }
        return nil
    }
}

