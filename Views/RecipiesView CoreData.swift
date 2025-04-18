import SwiftUI
import CoreData

// MARK: - Core Data Model
// Questo codice dovrebbe essere inserito in un file RecipeModel.xcdatamodeld
// Qui mostro come sarebbe la classe Recipe generata da Core Data

class RecipeEntity: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var ingredients: String
    @NSManaged var procedure: String
    @NSManaged var imageData: Data?
    
    var image: UIImage? {
        get {
            if let imageData = imageData {
                return UIImage(data: imageData)
            }
            return nil
        }
        set {
            imageData = newValue?.jpegData(compressionQuality: 0.7)
        }
    }
}

// MARK: - Core Data Manager
class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RecipeModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load Core Data stores: \(error)")
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let error = error as NSError
                print("Unresolved Core Data error: \(error), \(error.userInfo)")
            }
        }
    }
    
    // Crea una nuova ricetta
    func createRecipe(name: String, ingredients: String, procedure: String, image: UIImage?) -> RecipeEntity {
        let recipe = RecipeEntity(context: viewContext)
        recipe.id = UUID()
        recipe.name = name
        recipe.ingredients = ingredients
        recipe.procedure = procedure
        recipe.image = image
        saveContext()
        return recipe
    }
    
    // Carica tutte le ricette
    func fetchRecipes() -> [RecipeEntity] {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Failed to fetch recipes: \(error)")
            return []
        }
    }
    
    // Elimina una ricetta
    func deleteRecipe(_ recipe: RecipeEntity) {
        viewContext.delete(recipe)
        saveContext()
    }
    
    // Aggiorna una ricetta esistente
    func updateRecipe(_ recipe: RecipeEntity) {
        saveContext()
    }
}

// MARK: - Recipe Card Component
struct RecipeCard: View {
    let recipe: RecipeEntity
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
    let recipe: RecipeEntity
    
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
struct AppTheme {
    static let backgroundColor = Color.gray.opacity(0.05)
    static let accentColor = Color.orange
    static let cardColor = Color.accentColor.opacity(0.95)
    static let cornerRadius: CGFloat = 25
    static let spacing: CGFloat = 20
}

// MARK: - Custom Title View
struct CustomTitleView: View {
    var body: some View {
        HStack {
            Text("Recipes")
                .font(.largeTitle.bold())
                .foregroundColor(AppTheme.accentColor)
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .padding(.bottom, 5)
    }
}

// MARK: - Add Recipe View
struct AddRecipeView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var ingredients: String = ""
    @State private var procedure: String = ""
    @State private var image: UIImage?
    @State private var showImagePicker = false
    
    var onSave: (RecipeEntity) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Recipe Details")) {
                    TextField("Name", text: $name)
                    TextEditor(text: $ingredients)
                        .frame(height: 100)
                        .overlay(
                            VStack {
                                if ingredients.isEmpty {
                                    HStack {
                                        Text("Ingredients")
                                            .foregroundColor(.gray.opacity(0.7))
                                            .padding(.top, 8)
                                            .padding(.leading, 5)
                                        Spacer()
                                    }
                                }
                                Spacer()
                            }
                        )
                    
                    TextEditor(text: $procedure)
                        .frame(height: 150)
                        .overlay(
                            VStack {
                                if procedure.isEmpty {
                                    HStack {
                                        Text("Procedure")
                                            .foregroundColor(.gray.opacity(0.7))
                                            .padding(.top, 8)
                                            .padding(.leading, 5)
                                        Spacer()
                                    }
                                }
                                Spacer()
                            }
                        )
                }
                
                Section(header: Text("Image")) {
                    Button(action: {
                        showImagePicker = true
                    }) {
                        HStack {
                            Text("Select Image")
                            Spacer()
                            if image != nil {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    
                    if let selectedImage = image {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(12)
                            .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Add Recipe")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newRecipe = CoreDataManager.shared.createRecipe(
                            name: name,
                            ingredients: ingredients,
                            procedure: procedure,
                            image: image
                        )
                        onSave(newRecipe)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(name.isEmpty || ingredients.isEmpty)
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $image)
            }
        }
    }
}

// MARK: - Main Recipes View
struct RecipiesView: View {
    @State private var isAddRecipeViewPresented = false
    @State private var selectedRecipe: RecipeEntity? = nil
    @State private var recipes: [RecipeEntity] = []
    
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
                    CustomTitleView()
                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(recipes, id: \.id) { recipe in
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
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $isAddRecipeViewPresented) {
            AddRecipeView(onSave: { recipe in
                loadRecipes()
            })
            .accessibilityLabel("Add Recipe View. Fill in details to create a new recipe.")
        }
        .sheet(item: $selectedRecipe, onDismiss: {
            loadRecipes()
        }) { recipe in
            RecipeDetailView(recipe: recipe)
        }
        .onAppear {
            loadRecipes()
        }
    }
    
    // MARK: - Data Management
    
    /// Delete a recipe and save changes
    private func deleteRecipe(_ recipe: RecipeEntity) {
        CoreDataManager.shared.deleteRecipe(recipe)
        loadRecipes()
    }
    
    /// Load recipes from Core Data
    private func loadRecipes() {
        recipes = CoreDataManager.shared.fetchRecipes()
    }
}

// MARK: - Necessary Helpers
// ImagePicker per selezionare immagini dalla libreria
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

// Estensione per il FetchRequest di RecipeEntity
extension RecipeEntity {
    static func fetchRequest() -> NSFetchRequest<RecipeEntity> {
        return NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
    }
}
