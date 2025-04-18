//
//  ChallengesView.swift
//  ICook
//
//  Created by Fabrizio Vollaro on 10/12/24.
//


        

import SwiftUI

struct ChallengesView: View {
    @State private var selectedRecipes: Set<UUID> = [] // Ricette selezionate
    @State private var recipes: [Recipe] = []
    @State private var isGameStarted = false // Stato per iniziare il gioco

    var body: some View {
        NavigationView {
            VStack {
                Text("Select Recipes for the Challenge")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.black)
                    .padding()

                ScrollView {
                    if recipes.isEmpty {
                        Text("No recipes available. Create some recipes first!")
                            .foregroundColor(.gray)
                            .padding(.top, 50)
                    } else {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(recipes) { recipe in
                                VStack {
                                    HStack {
//                                        if let image = recipe.image {
//                                            Image(uiImage: image)
//                                                .resizable()
//                                                .scaledToFill()
//                                                .frame(width: 60, height: 60)
//                                                .clipShape(Circle())
//                                                .shadow(radius: 5)
//                                        }
                                        VStack(alignment: .leading) {
                                            Text(recipe.name)
                                                .font(.title3)
                                                .bold()
                                                .foregroundColor(selectedRecipes.contains(recipe.id) ? Color.white : Color.orange)
                                        }
                                        Spacer()
                                    }
                                    .padding()
                                    .frame(width: 170, height: 100)
                                    .background(selectedRecipes.contains(recipe.id) ? Color.orange.opacity(0.7) : Color.white)
                                    .cornerRadius(25)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(selectedRecipes.contains(recipe.id) ? Color.orange : Color.gray, lineWidth: 1)
                                    )
                                    .onTapGesture {
                                        toggleSelection(for: recipe) // Gestisci la selezione
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }

                Button(action: {
                    isGameStarted = true // Inizia la sfida
                }) {
                    Text("Start Challenge")
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedRecipes.isEmpty ? Color.gray : Color.orange)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(selectedRecipes.isEmpty)
                .padding(.bottom)
            }
            .navigationTitle("Challenges")
            .sheet(isPresented: $isGameStarted) {
                MemoryGameView(selectedRecipes: selectedRecipes.compactMap { id in
                    recipes.first(where: { $0.id == id })
                })
            }
            .onAppear {
                loadRecipes() // Carica le ricette da UserDefaults quando la vista appare
            }
        }
    }

    // Funzione per alternare la selezione
    private func toggleSelection(for recipe: Recipe) {
        if selectedRecipes.contains(recipe.id) {
            selectedRecipes.remove(recipe.id)
        } else {
            selectedRecipes.insert(recipe.id)
        }
    }
    
    // MARK: - Caricamento Ricette
    
    /// Carica ricette da UserDefaults (stesso metodo usato in RecipesView)
    private func loadRecipes() {
        if let data = UserDefaults.standard.data(forKey: "recipes"),
           let decodedRecipes = try? JSONDecoder().decode([Recipe].self, from: data) {
            recipes = decodedRecipes
            
            // Pulizia delle selezioni per assicurarsi che non ci siano ID non più validi
            selectedRecipes = selectedRecipes.filter { recipeId in
                recipes.contains { $0.id == recipeId }
            }
        }
    }
}


#Preview {
ChallengesView()
}
