//
//  RecipiesView.swift
//  ICook
//
//  Created by Fabrizio Vollaro on 10/12/24.
//

import SwiftUI

// MARK: - Recipe Card Component
struct RecipeCard: View {
    let recipe: Recipe
    let onDelete: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(recipe.name)
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .accessibilityLabel("Recipe name: \(recipe.name)")
                    
                    Text(recipe.ingredients)
                        .font(.subheadline)
                        .foregroundColor(.black.opacity(0.8))
                        .lineLimit(2)
                        .accessibilityLabel("Ingredients: \(recipe.ingredients)")
                }
                Spacer()
            }
            .padding()
            .frame(width: 170, height: 140)
            .background(AppTheme.cardColor)
            .cornerRadius(AppTheme.cornerRadius)
            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
            .accessibilityElement(children: .combine)
        }
        .contextMenu {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .accessibilityAction(named: "Delete \(recipe.name)") {
            onDelete()
        }
    }
}

// MARK: - Recipe Detail View
struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Recipe Image (if available)
                if let image = recipe.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 300)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
                
                // Recipe Title
                Text(recipe.name)
                    .font(.largeTitle.bold())
                    .foregroundColor(AppTheme.accentColor)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)
                
                // Ingredients Section
                RecipeSection(title: "Ingredients:", content: recipe.ingredients)
                
                // Procedure Section (if not empty)
                if !recipe.procedure.isEmpty {
                    RecipeSection(title: "Procedure:", content: recipe.procedure)
                }
                
                Spacer()
            }
            .padding()
        }
        .frame(maxWidth: 350)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 2)
        )
    }
}

// MARK: - Recipe Section Component
struct RecipeSection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title2.bold())
                .padding(.top, 5)
            
            Text(content)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityLabel("\(title) \(content)")
        }
        .padding(.bottom, 10)
    }
}

// MARK: - Theme Constants
extension AppTheme {
    static let accentColor = Color.orange
    //static let cardColor = Color.accentColor.opacity(0.95)
}

// MARK: - Custom Title View
struct CustomTitleView: View {
    var body: some View {
        HStack {
            Text("Recipes")
                .font(.largeTitle.bold())
                .foregroundColor(.black)
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .padding(.bottom, 5)
    }
}

// MARK: - Main Recipes View
struct RecipiesView: View {
    @State private var isAddRecipeViewPresented = false
    @State private var selectedRecipe: Recipe? = nil
    @State private var recipes: [Recipe] = []
    
    // Grid configuration
    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Custom Title instead of navigationTitle
                    HStack {
                        CustomTitleView()
                        
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
                        .padding(.trailing, 20)
                    }
                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(recipes) { recipe in
                                RecipeCard(recipe: recipe) {
                                    deleteRecipe(recipe)
                                }
                                .onTapGesture {
                                    selectedRecipe = recipe
                                }
                            }
                        }
                        .padding(20)
                    }
                }
            }
            // No navigation title here
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: {
//                        isAddRecipeViewPresented = true
//                    }) {
//                        Image(systemName: "plus.circle")
//                            .resizable()
//                            .frame(width: 35, height: 35)
//                            .foregroundColor(.orange)
//                            .bold()
//                            .accessibilityLabel("Add a new recipe.")
//                    }
//                }
//            }
            
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Assicura compatibilità tra dispositivi
        .sheet(isPresented: $isAddRecipeViewPresented) {
            AddRecipeView(onSave: { recipe in
                addRecipe(recipe)
            })
            .accessibilityLabel("Add Recipe View. Fill in details to create a new recipe.")
        }
        .sheet(item: $selectedRecipe) { recipe in
            RecipeDetailView(recipe: recipe)
        }
        .onAppear {
            loadRecipes()
        }
    }
    
    // MARK: - Data Management
    
    /// Add a new recipe and save changes
    private func addRecipe(_ recipe: Recipe) {
        recipes.append(recipe)
        saveRecipes()
        isAddRecipeViewPresented = false
    }
    
    /// Delete a recipe and save changes
    private func deleteRecipe(_ recipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes.remove(at: index)
            saveRecipes()
        }
    }
    
    /// Save recipes to persistent storage
    private func saveRecipes() {
        if let encodedData = try? JSONEncoder().encode(recipes) {
            UserDefaults.standard.set(encodedData, forKey: "recipes")
        }
    }
    
    /// Load recipes from persistent storage
    private func loadRecipes() {
        if let data = UserDefaults.standard.data(forKey: "recipes"),
           let decodedRecipes = try? JSONDecoder().decode([Recipe].self, from: data) {
            recipes = decodedRecipes
        }
    }
}




#Preview {
RecipiesView()
}
