//
//  RecipeStore.swift
//  ICook
//
//  Created by Fabrizio Vollaro on 17/12/24.
//

import SwiftUI

class RecipeStore: ObservableObject {
    @Published var recipes: [Recipe] = [] // Elenco delle ricette condivise
}
