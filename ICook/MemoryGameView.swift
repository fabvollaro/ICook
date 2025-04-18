//
//  MemoryGameView.swift
//  ICook
//
//  Created by Fabrizio Vollaro on 11/12/24.
//

import SwiftUI

struct MemoryGameView: View {
    let selectedRecipes: [Recipe] // Ricette selezionate
    @State private var shuffledIngredients: [String] = []
    @State private var currentRecipe: Recipe?
    @State private var selectedAnswer: UUID? = nil
    @State private var isAnswerCorrect: Bool? = nil
    @State private var showingOptions: Bool = false

    var body: some View {
        VStack {
            Text("Memory Challenge")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.black)
                .padding(.top, 20)
            
            Image("Mascotte2")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 300, maxHeight: 200)
                .padding()

            if let recipe = currentRecipe {
                VStack(spacing: 20) {
                    Text("Which recipe matches these ingredients?")
                        .font(.headline)
                    
                    Text(recipe.ingredients)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color.orange.opacity(0.3))
                        .cornerRadius(15)
                    
                    // Bottone per mostrare le opzioni
                    Button(action: {
                        showingOptions = true
                    }) {
                        HStack {
                            Text(selectedAnswer == nil ? "Select a recipe" :
                                selectedRecipes.first(where: { $0.id == selectedAnswer })?.name ?? "")
                                .foregroundColor(selectedAnswer == nil ? .gray : .black)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .frame(maxWidth: 300)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    }
                    .actionSheet(isPresented: $showingOptions) {
                        ActionSheet(
                            title: Text("Choose a recipe"),
                            buttons: createActionSheetButtons()
                        )
                    }
                    
                    if let isCorrect = isAnswerCorrect {
                        Text(isCorrect ? "Correct!" : "Wrong!")
                            .font(.title2)
                            .foregroundColor(isCorrect ? .green : .red)
                    }

                    Button(action: checkAnswer) {
                        Text("Submit Answer")
                            .bold()
                            .padding()
                            .frame(maxWidth: 300)
                            .background(selectedAnswer == nil ? Color.gray : Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(selectedAnswer == nil)
                    //.opacity(selectedAnswer == nil ? 0.6 : 1)
                }
                .padding()
            } else {
                Text("You've completed the challenge!")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.green)
                    .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .onAppear(perform: startGame)
    }

    private func createActionSheetButtons() -> [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = selectedRecipes.map { recipe in
            .default(Text(recipe.name)) {
                selectedAnswer = recipe.id
                isAnswerCorrect = nil
            }
        }
        
        buttons.append(.cancel())
        return buttons
    }

    private func startGame() {
        guard !selectedRecipes.isEmpty else { return }
        shuffledIngredients = selectedRecipes.flatMap { $0.ingredients.split(separator: ",").map(String.init) }.shuffled()
        currentRecipe = selectedRecipes.first
        selectedAnswer = nil
        isAnswerCorrect = nil
    }

    private func checkAnswer() {
        guard let recipe = currentRecipe, let answer = selectedAnswer else { return }
        
        let isCorrect = answer == recipe.id
        isAnswerCorrect = isCorrect
        
        if isCorrect {
            // Passa alla prossima ricetta dopo un breve ritardo
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if let currentIndex = selectedRecipes.firstIndex(where: { $0.id == recipe.id }),
                   currentIndex < selectedRecipes.count - 1 {
                    currentRecipe = selectedRecipes[currentIndex + 1]
                    selectedAnswer = nil
                    isAnswerCorrect = nil
                } else {
                    currentRecipe = nil // Fine del gioco
                }
            }
        }
    }
}


struct MemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        MemoryGameView(selectedRecipes: [
            Recipe(name: "Pasta", ingredients: "Pasta, Tomato Sauce", procedure: "Boil pasta, add sauce", image: nil),
            Recipe(name: "Pizza", ingredients: "Dough, Tomato, Cheese", procedure: "Bake with toppings", image: nil)
        ])
    }
}
