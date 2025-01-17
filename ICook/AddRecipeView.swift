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
        picker.accessibilityLabel = "Image picker. Select an image from your photo library."
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

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
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
    @State private var recipeName: String = ""
    @State private var newIngredient: String = ""
    @State private var ingredients: [String] = []
    @State private var procedure: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var isImagePickerPresented: Bool = false // Stato per mostrare l'ImagePicker
    
    var onSave: (Recipe) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Recipe Name")) {
                    TextField("Enter recipe name", text: $recipeName)
                        .accessibilityLabel("Recipe name text field.")
                        .accessibilityHint("Enter the name of your recipe.")
                }
                
                Section(header: Text("Ingredients")) {
                    HStack {
                        TextField("Enter an ingredient", text: $newIngredient)
                            .accessibilityLabel("Ingredient text field.")
                            .accessibilityHint("Enter the name of an ingredient.")
                        Button(action: {
                            guard !newIngredient.isEmpty else { return }
                            ingredients.append(newIngredient)
                            newIngredient = ""
                        }) {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.accentColor)
                                .accessibilityLabel("Add ingredient button.")
                                .accessibilityHint("Tap to add the entered ingredient.")
                        }
                    }
                    
                    if !ingredients.isEmpty {
                        List {
                            ForEach(ingredients, id: \.self) { ingredient in
                                HStack {
                                    Text(ingredient)
                                        .accessibilityLabel("Ingredient: \(ingredient).")
                                    Spacer()
                                    Button(action: {
                                        ingredients.removeAll { $0 == ingredient }
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.accentColor)
                                            .accessibilityLabel("Delete ingredient button.")
                                            .accessibilityHint("Tap to remove \(ingredient) from the list.")
                                    }
                                }
                            }
                        }
                    } else {
                        Text("No ingredients added yet.")
                            .foregroundColor(.gray)
                            .italic()
                            .accessibilityLabel("No ingredients added.")
                    }
                }
                
                Section(header: Text("Procedure")) {
                    TextEditor(text: $procedure)
                        .frame(height: 100)
                        .accessibilityLabel("Recipe procedure text editor.")
                        .accessibilityHint("Enter the steps to prepare the recipe.")
                }
                
                Section(header: Text("Add a Photo")) {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 5)
                    } else {
                        Text("No image selected")
                            .foregroundColor(.gray)
                            .italic()
                            .accessibilityLabel("No image selected.")
                    }
                    
                    Button("Select Image") {
                        isImagePickerPresented = true // Mostra l'ImagePicker
                    }
                    .accessibilityLabel("Select image button.")
                    .accessibilityHint("Tap to choose an image for the recipe.")
                }
            }
            .navigationTitle("Add Recipe")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        guard !recipeName.isEmpty, !ingredients.isEmpty else { return }
                        let newRecipe = Recipe(
                            name: recipeName,
                            ingredients: ingredients.joined(separator: ", "),
                            procedure: procedure,
                            image: selectedImage
                        )
                        onSave(newRecipe)
                        dismiss()
                    }
                    .accessibilityLabel("Save recipe button.")
                    .accessibilityHint("Tap to save the recipe.")
                }
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImage: $selectedImage)
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
