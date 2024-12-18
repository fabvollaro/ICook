//
//  RecipiesView.swift
//  ICook
//
//  Created by Fabrizio Vollaro on 10/12/24.
//

import SwiftUI

struct RecipiesView: View {
    @State private var isAddRecipeViewPresented = false
    @State private var selectedRecipe: Recipe? = nil
    @State private var recipes: [Recipe] = []

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.05)
                    .ignoresSafeArea()
                
                VStack {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(recipes) { recipe in
                                VStack {
                                    HStack {
                                        if let image = recipe.image {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 80, height: 80)
                                                .clipShape(Circle())
                                                .shadow(radius: 5)
                                        }
                                        VStack(alignment: .leading) {
                                            Text(recipe.name)
                                                .font(.title2)
                                                .bold()
                                                .foregroundColor(recipe.image == nil ? .white : .orange)
                                            Text(recipe.ingredients)
                                                .font(.subheadline)
                                                .foregroundColor(recipe.image == nil ? .white.opacity(0.8) : .gray)
                                                .lineLimit(2)
                                        }
                                        Spacer()
                                    }
                                    .padding()
                                    .frame(width: 170, height: 140)
                                    .background(recipe.image == nil ? Color.orange : Color.white)
                                    .cornerRadius(25)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color.orange, lineWidth: 3)
                                    )
                                    .shadow(color: .gray.opacity(0.4), radius: 10, x: 0, y: 5)
                                }
                                .onTapGesture {
                                    selectedRecipe = recipe
                                }
                                .contextMenu {
                                    Button(role: .destructive) {
                                        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
                                            recipes.remove(at: index)
                                            saveRecipes() // Salva dopo l'eliminazione
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isAddRecipeViewPresented = true
                    }) {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(.orange)
                            .bold()
                    }
                }
            }
            .sheet(isPresented: $isAddRecipeViewPresented) {
                AddRecipeView(onSave: { recipe in
                    recipes.append(recipe)
                    saveRecipes() // Salva dopo l'aggiunta
                    isAddRecipeViewPresented = false
                })
            }
        }
        .onAppear {
            loadRecipes() // Carica le ricette all'avvio
        }
    }
    
    // Salvataggio delle ricette
    func saveRecipes() {
        if let encodedData = try? JSONEncoder().encode(recipes) {
            UserDefaults.standard.set(encodedData, forKey: "recipes")
        }
    }

    // Caricamento delle ricette
    func loadRecipes() {
        if let data = UserDefaults.standard.data(forKey: "recipes"),
           let decodedRecipes = try? JSONDecoder().decode([Recipe].self, from: data) {
            recipes = decodedRecipes
        }
    }
}








#Preview {
RecipiesView()
}
