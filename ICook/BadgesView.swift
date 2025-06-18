//
//  BadgesView.swift
//  ICook
//
//  Created by Fabrizio Vollaro on 17/12/24.
//

import SwiftUI

struct BadgesView: View {
    
    @ObservedObject var manager = AchievementManager.shared
    @State private var isFlipped = false
    @State private var rotation: Double = 0

    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Badges")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 20)
                
                ZStack {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(manager.achievements) { badge in
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 150, height: 150)
                                .overlay(
                                    Image(badge.isUnlocked ? badge.imageName : "badgeLocked")
                                        .resizable()
                                        .scaledToFit()
                                        .padding()
                                )
                                .shadow(color: .black.opacity(0.5), radius: 8, x: 0, y: 5)
                        }
                    }
                    .opacity(isFlipped ? 0 : 1)
                    .rotation3DEffect(Angle(degrees: rotation), axis: (x: 0, y: 1, z: 0))
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(manager.achievements) { badge in
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 150, height: 150)
                                .overlay(
                                    VStack {
                                        Text(badge.title)
                                            .font(.headline)
                                        Text(badge.description)
                                            .font(.caption)
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal, 5)
                                    }
                                )
                                .shadow(color: .black.opacity(0.5), radius: 8, x: 0, y: 5)
                        }
                    }
                    .opacity(isFlipped ? 1 : 0)
                    .rotation3DEffect(Angle(degrees: rotation + 180), axis: (x: 0, y: 1, z: 0))
                }
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    flipCard()
                }
                .onAppear {
                    startInitialAnimation()
                }
                .padding()
            }
        }
    }
    
    private func flipCard() {
        withAnimation(.easeInOut(duration: 0.6)) {
            rotation += 180
            isFlipped.toggle()
        }
    }
    
    private func startInitialAnimation() {
        withAnimation(.easeInOut(duration: 1.0)) {
            rotation += 360
        }
    }
}

    
#Preview {
    BadgesView()
}
