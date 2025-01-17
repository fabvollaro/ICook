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
//                                        if let image = recipe.image {
//                                            Image(uiImage: image)
//                                                .resizable()
//                                                .scaledToFill()
//                                                .frame(width: 80, height: 80)
//                                                .clipShape(Circle())
//                                                .shadow(radius: 5)
//                                        }
                                        VStack(alignment: .leading) {
                                            Text(recipe.name)
                                                .font(.title2)
                                                .bold()
                                                .foregroundColor(/*recipe.image == nil ? .white : */.orange)
                                                .accessibilityLabel("Recipe name: \(recipe.name).")
                                            Text(recipe.ingredients)
                                                .font(.subheadline)
                                                .foregroundColor(/*recipe.image == nil ? */.black /*: .gray*/)
                                                .lineLimit(2)
                                                .accessibilityLabel("Ingredients: \(recipe.ingredients).")
                                        }
                                        Spacer()
                                    }
                                    .padding()
                                    .frame(width: 170, height: 140)
                                    .background(/*recipe.image == nil ? Color.orange : */Color.white)
                                    .cornerRadius(25)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color.black, lineWidth: 0.2)
                                    )
                                    .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 2)
                                    .accessibilityElement(children: .combine) // Tratta l'intera scheda come un unico elemento
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
                                .accessibilityAction(named: "Delete \(recipe.name)") {
                                    if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
                                        recipes.remove(at: index)
                                        saveRecipes()
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
                            .accessibilityLabel("Add a new recipe.")
                    }
                }
            }
            .sheet(isPresented: $isAddRecipeViewPresented) {
                AddRecipeView(onSave: { recipe in
                    recipes.append(recipe)
                    saveRecipes() // Salva dopo l'aggiunta
                    isAddRecipeViewPresented = false
                })
                .accessibilityLabel("Add Recipe View. Fill in details to create a new recipe.")
            }
            .sheet(item: $selectedRecipe) { recipe in
                VStack(alignment: .leading, spacing: 20) {
                    if let image = recipe.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 300)
                            .cornerRadius(15)
                            .shadow(radius: 10)
                    }

                    Text(recipe.name)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.orange)
                        .frame(maxWidth: .infinity, alignment: .center) // Centra il testo orizzontalmente
                        .multilineTextAlignment(.center) // Assicura che anche in caso di più righe sia centrato
                    
                    // Sezione "Ingredients"
                            VStack(alignment: .leading, spacing: 5) { // Spacing ridotto tra titolo e contenuto
                                Text("Ingredients:")
                                    .font(.title2)
                                    .bold()
                                    .padding(.top)
                                Text(recipe.ingredients)
                                    .font(.body)
                                    .accessibilityLabel("Ingredients: \(recipe.ingredients).")
                            }
                            .padding(.bottom, 10) // Spazio tra "Ingredients" e "Procedure"

                    // Sezione "Procedure"
                            if !recipe.procedure.isEmpty {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Procedure:")
                                        .font(.title2)
                                        .bold()
                                        .padding(.top)
                                    Text(recipe.procedure)
                                        .font(.body)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .accessibilityLabel("Procedure: \(recipe.procedure).")
                                }
                            }

                    Spacer()
                }
                .padding()
                .frame(maxWidth: 350) // Imposta una larghezza massima maggiore
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(radius: 10)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 0.2)
                )

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
