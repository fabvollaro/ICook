//
//  AddRecipeView.swift
//  ICook
//
//  Created by Fabrizio Vollaro on 10/12/24.
//

import SwiftUI
import UIKit


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) var dismiss

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = uiImage
            }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}





struct AddRecipeView: View {
    @Environment(\.dismiss) var dismiss
    @State private var recipeName: String = "" // Variabile locale per il nome
    @State private var newIngredient: String = "" // Per aggiungere singoli ingredienti
    @State private var ingredients: [String] = [] // Lista di ingredienti
    @State private var procedure: String = ""
    @State private var selectedImage: UIImage? = nil
    
    var onSave: (Recipe) -> Void // Callback per salvare la ricetta
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Recipe Name")) {
                    TextField("Enter recipe name", text: $recipeName)
                }
                
                Section(header: Text("Ingredients")) {
                    HStack {
                        TextField("Enter an ingredient", text: $newIngredient)
                        Button(action: {
                            guard !newIngredient.isEmpty else { return }
                            ingredients.append(newIngredient)
                            newIngredient = "" // Pulisce il campo
                        }) {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.green)
                        }
                    }
                    
                    if !ingredients.isEmpty {
                        List {
                            ForEach(ingredients, id: \.self) { ingredient in
                                HStack {
                                    Text(ingredient)
                                    Spacer()
                                    Button(action: {
                                        ingredients.removeAll { $0 == ingredient }
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                        }
                    } else {
                        Text("No ingredients added yet.")
                            .foregroundColor(.gray)
                            .italic()
                    }
                }
                
                Section(header: Text("Procedure")) {
                    TextEditor(text: $procedure)
                        .frame(height: 100)
                }
                
                Section(header: Text("Add a Photo")) {
                    Button("Select Image") {
                        // Codice per selezionare l'immagine
                    }
                }
            }
            .navigationTitle("Add Recipe")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        guard !recipeName.isEmpty, !ingredients.isEmpty else { return }
                        let newRecipe = Recipe(
                            name: recipeName,
                            ingredients: ingredients.joined(separator: ", "), // Unisce gli ingredienti in una stringa
                            procedure: procedure,
                            image: selectedImage
                        )
                        onSave(newRecipe)
                        dismiss()
                    }
                }
            }
        }
    }
    
    
    
    
    private func saveRecipe() {
        guard !recipeName.isEmpty, !ingredients.isEmpty else { return }
        
        print("Recipe Saved:")
        print("Name: \(recipeName)")
        print("Ingredients: \(ingredients)")
        print("Procedure: \(procedure)")
    }
}

  


#Preview {
    AddRecipeView { recipe in
        print("Mock save: \(recipe)")
    }
}
