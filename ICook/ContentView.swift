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

    @State private var showWelcomeText = false // Stato per animare la scritta "Welcome to ICook!"
    @State private var showInstructions = false // Stato per mostrare le istruzioni dopo un ritardo

    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.04)
                    .shadow(color: .accent.opacity(0.3), radius: 5, x: 0, y: 0)
                    .ignoresSafeArea()
                
                VStack {
                    // Rettangolo arrotondato come sfondo per la mascotte
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.gray.opacity(0.04))
                            .frame(width: 470, height: 400)
                            .shadow(color: .accent.opacity(0.9), radius: 5, x: 0, y: 0)
                            .accessibilityHidden(true)
                        
                        // Animazione "Welcome to I Cook!"
                        Text("Welcome to I Cook!")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.accent)
                            .padding(.trailing, 50)
                            .padding(.bottom, 180)
                            .opacity(showWelcomeText ? 1 : 0) // Controlla visibilità
                            .offset(y: showWelcomeText ? 0 : -50) // Movimento verticale
                            .animation(.easeInOut(duration: 1.5), value: showWelcomeText)
                            .accessibilityLabel("Welcome to I Cook! A cooking app where you can insert your recipes and face challenges.")
                        
                        // Animazione "Insert your recipes and face your challenges"
                        Text(" Insert your recipes \n and face your \n challenges")
                            .font(.title)
//                            .bold()
                            .foregroundColor(.black)
                            .padding(.trailing, 140)
                            .padding(.top, 230)
                            .opacity(showInstructions ? 1 : 0) // Controlla visibilità
                            .animation(.easeInOut(duration: 1).delay(0), value: showInstructions)
                        
                        // Mascotte
                        Image("Mascotte3")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 600, height: 300)
                            .padding(.leading, 235)
                            .padding(.top, 100)
                            .accessibilityLabel("A friendly mascot holding a cooking pan.")
                    }
                    .padding(.top, -70)
                    
                    Spacer()
                    
                    // Box Ricette e Sfide
                    HStack {
                        // Prima box: Recipes
                        NavigationLink(destination: RecipiesView()) {
                            VStack(alignment: .leading, spacing: 0) {
                                // Sezione per il titolo
                                Text("Recipes")
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(.accent)
                                    .padding()
                                    .frame(maxWidth: .infinity, minHeight: 20, alignment: .center)
                                    .background(Color.white.opacity(1))
                                    .cornerRadius(25, corners: [.topLeft, .topRight])
                                
                                // Sezione per i contenuti
                                HStack {
                                    Spacer()
                                    Image("Mascotte2")
                                        .resizable()
                                        .padding()
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity, minHeight: 150)
                                .background(Color.white.opacity(1))
                                .cornerRadius(25, corners: [.bottomLeft, .bottomRight])
                            }
                            .frame(width: 180, height: 220)
                            .shadow(color: .black.opacity(0.9), radius: 2, x: 0, y: 0)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.black, lineWidth: 0.1)
                            )
                        }
                        
                        // Seconda box: Challenges
                        NavigationLink(destination: ChallengesView()) {
                            VStack(alignment: .leading, spacing: 0) {
                                // Sezione per il titolo
                                Text("Challenges")
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(.accent)
                                    .padding()
                                    .frame(maxWidth: .infinity, minHeight: 20, alignment: .center)
                                    .background(Color.white.opacity(1))
                                    .cornerRadius(25, corners: [.topLeft, .topRight])
                                
                                // Sezione per i contenuti
                                HStack {
                                    Spacer()
                                    Image("Mascotte2")
                                        .resizable()
                                        .padding()
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity, minHeight: 150)
                                .background(Color.white.opacity(1))
                                .cornerRadius(25, corners: [.bottomLeft, .bottomRight])
                            }
                            .frame(width: 180, height: 220)
                            .shadow(color: .black.opacity(0.9), radius: 2, x: 0, y: 0)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.black, lineWidth: 0.1)
                            )
                        }
                    }
                    .padding(.bottom, 35)
                    
                    // Sezione Awards
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Awards")
                                .font(.title)
                                .bold()
                                .foregroundColor(.accent)
                            
                            Spacer()
                            
                            Button(action: {
                                isBadgesViewPresented = true
                            }) {
                                Text("See All")
                                    .font(.headline)
                                    .foregroundColor(.accent)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white.opacity(1))
                        .cornerRadius(25, corners: [.topLeft, .topRight])
                        
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
                                       .background(Color.white.opacity(1)) // Sfondo inferiore
                                       .cornerRadius(25, corners: [.bottomLeft, .bottomRight]) // Angoli arrotondati solo in basso
                                   }
                                   .frame(width: 370, height: 150)
                                   .shadow(color: .black.opacity(1), radius: 2, x: 0, y: 0)
                                   .sheet(isPresented: $isBadgesViewPresented) {
                                       BadgesView()
                                   }
                                   .padding(.bottom, 0)
                                   .overlay(
                                       RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.black, lineWidth: 0.1)
                                           .frame(width: 370, height: 168) // Dimensioni personalizzate
                                   )


                }
                
            }
            .onAppear {
                // Attiva l'animazione
                withAnimation {
                    showWelcomeText = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        showInstructions = true
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
