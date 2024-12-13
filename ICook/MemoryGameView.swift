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
    @State private var userAnswer: String = ""
    @State private var isAnswerCorrect: Bool? = nil

    var body: some View {
        VStack{
            
            Text("Memory Challenge")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.orange)
                .offset(y: -50)
                .padding()
            
            Image("Mascotte2")
                .resizable()
                .scaledToFit() // Adatta l'immagine al contenitore mantenendo le proporzioni
                .frame(width: 600, height: 300)
                .offset(y: -50)

            if let recipe = currentRecipe {
                VStack {
                    Text("Which recipe matches these ingredients?")
                        .font(.headline)
                        .offset(y: -50)
                    Text(recipe.ingredients)
                        .font(.body)
                        .padding()
                        .background(Color.orange.opacity(0.3))
                        .cornerRadius(15)
                        .offset(y: -50)
                }
                .padding()

                TextField("Enter Recipe Name", text: $userAnswer)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .offset(y: -50)
                    .padding()

                if let isCorrect = isAnswerCorrect {
                    Text(isCorrect ? "Correct!" : "Wrong!")
                        .font(.title2)
                        .foregroundColor(isCorrect ? .green : .red)
                }

                Button(action: checkAnswer) {
                    Text("Submit Answer")
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .offset(y: -50)
                }
                .padding(.horizontal)
            } else {
                Text("You've completed the challenge!")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.green)
            }
        }
        .onAppear(perform: startGame)
        .padding()
    }

    private func startGame() {
        guard !selectedRecipes.isEmpty else { return }
        shuffledIngredients = selectedRecipes.flatMap { $0.ingredients.split(separator: ",").map(String.init) }.shuffled()
        currentRecipe = selectedRecipes.first
    }

    private func checkAnswer() {
        guard let recipe = currentRecipe else { return }
        if userAnswer.lowercased() == recipe.name.lowercased() {
            isAnswerCorrect = true
            // Passa alla prossima ricetta
            if let currentIndex = selectedRecipes.firstIndex(where: { $0.id == recipe.id }),
               currentIndex < selectedRecipes.count - 1 {
                currentRecipe = selectedRecipes[currentIndex + 1]
                userAnswer = ""
                isAnswerCorrect = nil
            } else {
                currentRecipe = nil // Fine del gioco
            }
        } else {
            isAnswerCorrect = false
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