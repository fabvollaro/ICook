//
//  BadgesView.swift
//  ICook
//
//  Created by Fabrizio Vollaro on 17/12/24.
//

import SwiftUI

struct BadgesView: View {
    
    @State private var isFlipped = false
    @State private var rotation: Double = 0
    @State private var initialRotation: Double = 0
    
    let badges: [String] = (1...18).map { "Badge\($0)" } // Nomi degli asset
    
    let columns: [GridItem] = [
                GridItem(.flexible()),
        //        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            VStack{
            Text("Badges")
                .font(.largeTitle)
                .bold()
                .padding(.top, 20)
            
           
                ZStack {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(badges, id: \.self) { badgeName in
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 150, height: 150)
                                .overlay(
                                    Circle()
                                        .stroke(Color.orange, lineWidth: 0)
                                )
                                .shadow(color: .black.opacity(0.5), radius: 8, x: 0, y: 5)
                                .overlay(
                                    Image("badge1F")
                                        .resizable()
                                        .scaledToFit()
                                        //.clipShape(Circle())
                                )
                        }
                    }//End LazyVGrid
                    .opacity(isFlipped ? 0 : 1)
                    .rotation3DEffect(Angle(degrees: rotation), axis: (x: 0, y: 1, z: 0))
                    
                    
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(badges, id: \.self) { badgeName in
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 150, height: 150)
                            
                                .overlay(
                                    Circle()
                                        .stroke(Color.black, lineWidth: 2)
                                )
                                .shadow(color: .black.opacity(0.5), radius: 8, x: 0, y: 5)
                                .overlay(
                                    Text("Obiettivo") // Testo al centro del cerchio
                                        .font(.headline) // Modifica lo stile del testo
                                        .foregroundColor(.black) // Colore del testo
                                )
                        }
                    }//End LazyVGrid
                    .opacity(isFlipped ? 1 : 0)
                    .rotation3DEffect(Angle(degrees: rotation + 180), axis: (x: 0, y: 1, z: 0))
                    
                    
                }//End ZStack
                .frame(maxWidth: .infinity, alignment: .center)
                .onTapGesture {
                    flipCard()
                    
                }
                .onAppear {
                    startInitialAnimation() // Avvia l'animazione iniziale
                }
                
                .padding()
            }
        }
        
    }
    
    private func flipCard() {
        withAnimation(.easeInOut(duration: 0.6)) {
            rotation += 180  // Increment rotation by 180 degrees
            isFlipped.toggle()  // Toggle flip state
        }
    }
    
    private func startInitialAnimation() {
            withAnimation(.easeInOut(duration: 1.0)) {
                rotation += 360 // Ruota i cerchi di 360 gradi
            }
        }
    
}
    
#Preview {
    BadgesView()
}
