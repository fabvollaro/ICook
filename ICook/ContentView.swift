//
//  ContentView.swift
//  ICook
//
//  Created by Fabrizio Vollaro on 09/12/24.
//

import SwiftUI


struct RoundedCorner: Shape {
var radius: CGFloat = 25.0
var corners: UIRectCorner = .allCorners

func path(in rect: CGRect) -> Path {
let path = UIBezierPath(
    roundedRect: rect,
    byRoundingCorners: corners,
    cornerRadii: CGSize(width: radius, height: radius)
)
return Path(path.cgPath)
}
}

extension View {
func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
clipShape(RoundedCorner(radius: radius, corners: corners))
}
}


struct ContentView: View {
    
    @StateObject private var recipeStore = RecipeStore()
    
    @State private var isBadgesViewPresented = false // Stato per gestire la modale

var body: some View {

NavigationView {
    
    ZStack {
        Color.gray.opacity(0.05)
            .ignoresSafeArea()
        
        VStack{
            
            // Rettangolo arrotondato come sfondo per la mascotte
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.accentColor.opacity(1))
                    .frame(width: 470, height: 400)
                .shadow(color: .gray.opacity(0.4), radius: 10, x: 0, y: 5)
                
                // Inserisci l'immagine sopra il rettangolo
                    
                    Text("Welcome to I Cook!")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.trailing, 110)
                        .padding(.bottom, 120)
                
                Text("Insert your recipes \n and face your \n challenges")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.trailing, 160)
                    .padding(.top, 180)
                    
                    
                    Image("Mascotte3")
                        .resizable()
                        .scaledToFit() // Adatta l'immagine al contenitore mantenendo le proporzioni
                        .frame(width: 600, height: 300)
                        .offset(x: 115, y: 50)
                
                
            }
            .offset(y: -60)

            
            HStack{
                
                // Prima box: Recipies
                                NavigationLink(destination: RecipiesView()) {
                                    VStack(alignment: .leading, spacing: 0) {
                                        // Sezione per il titolo
                                        Text("Recipes")
                                            .font(.title)
                                            .bold()
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(maxWidth: .infinity, minHeight: 20, alignment: .center) // Allinea il testo a sinistra
                                            .background(Color.accentColor.opacity(1)) // Sfondo per la parte superiore
                                            .cornerRadius(25, corners: [.topLeft, .topRight]) // Angoli arrotondati solo in alto
                                        
                                        // Sezione per i contenuti
                                        HStack {
                                            Spacer()
                                            Image("Mascotte2")
                                                .resizable()
                                                .padding()
                                            Spacer()
                                        }
                                        .frame(maxWidth: .infinity, minHeight: 150)
                                        .background(Color.accentColor.opacity(1)) // Sfondo inferiore
                                        .cornerRadius(25, corners: [.bottomLeft, .bottomRight]) // Angoli arrotondati solo in basso
                                    }
                                    .frame(width: 180, height: 220)
                                    .shadow(color: .gray.opacity(0.4), radius: 10, x: 0, y: 5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color.orange, lineWidth: 3)
                                    )
                                }
                
                // Seconda box: Challenges
                                NavigationLink(destination: ChallengesView()) {
                                    VStack(alignment: .leading, spacing: 0) {
                                        // Sezione per il titolo
                                        Text("Challenges")
                                            .font(.title)
                                            .bold()
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(maxWidth: .infinity, minHeight: 20, alignment: .center) // Allinea il testo a sinistra
                                            .background(Color.accentColor.opacity(1)) // Sfondo per la parte superiore
                                            .cornerRadius(25, corners: [.topLeft, .topRight]) // Angoli arrotondati solo in alto
                                        
                                        // Sezione per i contenuti
                                        HStack {
                                            Spacer()
                                            Image("Mascotte2")
                                                .resizable()
                                                .padding()
                                            Spacer()
                                        }
                                        .frame(maxWidth: .infinity, minHeight: 150)
                                        .background(Color.accentColor.opacity(1)) // Sfondo inferiore
                                        .cornerRadius(25, corners: [.bottomLeft, .bottomRight]) // Angoli arrotondati solo in basso
                                    }
                                    .frame(width: 180, height: 220)
                                    .shadow(color: .gray.opacity(0.4), radius: 10, x: 0, y: 5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color.orange, lineWidth: 3)
                                    )
                                }
                
            } //End HStack
            .offset(y: -40)
            
            VStack(alignment: .leading, spacing: 0) {
                // Sezione per il titolo e il pulsante "See All"
                HStack {
                    Text("Awards")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        isBadgesViewPresented = true
                    }) {
                        Text("See All")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.accentColor.opacity(1)) // Sfondo comune per titolo e pulsante
                .cornerRadius(25, corners: [.topLeft, .topRight]) // Angoli arrotondati solo in alto

                
                // Sezione per i contenuti
                HStack {
                    Spacer()
                    Circle()
                        .fill(Color.gray.opacity(0.2)) // Colore di sfondo opzionale
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Image("badge1T") // Nome della tua immagine
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                )
                                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 5)
                    Spacer()
                    Circle()
                        .fill(Color.gray.opacity(0.2)) // Colore di sfondo opzionale
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Image("badge1F") // Nome della tua immagine
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                )
                                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 5)
                    Spacer()
                    
                        Circle()
                            .fill(Color.gray.opacity(0.2)) // Colore di sfondo opzionale
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image("badge1F") // Nome della tua immagine
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                           )
                            .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 5)
                    
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, minHeight: 100)
                .background(Color.accentColor.opacity(1)) // Sfondo inferiore
                .cornerRadius(25, corners: [.bottomLeft, .bottomRight]) // Angoli arrotondati solo in basso
            }
            .frame(width: 370, height: 150)
            .shadow(color: .gray.opacity(0.4), radius: 10, x: 0, y: 5)
            .sheet(isPresented: $isBadgesViewPresented) {
                BadgesView()
            }
            .offset(y: -10)
            
        } //End VStack
        
    }
    
} //End Nav View


} //End Body
} //End View


#Preview {
ContentView()
}
