//
//  ContentView.swift
//  ICook
//
//  Created by Fabrizio Vollaro on 09/12/24.
//

import SwiftUI

// MARK: - Utilities
struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    init(radius: CGFloat = 25, corners: UIRectCorner = .allCorners) {
        self.radius = radius
        self.corners = corners
    }
    
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
    
    /// Applies a consistent card style to a view
    func cardStyle(backgroundColor: Color = .accentColor.opacity(0.95), shadowRadius: CGFloat = 4) -> some View {
        self
            .background(backgroundColor)
            .cornerRadius(25)
            .shadow(color: .black.opacity(0.2), radius: shadowRadius, x: 0, y: 2)
    }
}

// MARK: - Theme Constants
struct AppTheme {
    static let backgroundColor = Color.gray.opacity(0.04)
    static let cardColor = Color.accentColor.opacity(0.95)
    static let textPrimary = Color.white
    static let textSecondary = Color.black
    static let spacing: CGFloat = 20
    static let cornerRadius: CGFloat = 25
}

// MARK: - Subcomponents
struct NavigationCard<Destination: View>: View {
    let title: String
    let destination: Destination
    let imageAsset: String
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack(alignment: .leading, spacing: 0) {
                // Title section
                Text(title)
                    .font(.title2.bold())
                    .foregroundColor(AppTheme.textPrimary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(AppTheme.cardColor)
                    .cornerRadius(AppTheme.cornerRadius, corners: [.topLeft, .topRight])
                
                // Content section
                Image(imageAsset)
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(AppTheme.cardColor)
                    .cornerRadius(AppTheme.cornerRadius, corners: [.bottomLeft, .bottomRight])
            }
            .frame(width: width, height: height)
            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
    }
}

struct BadgeCircle: View {
    let imageAsset: String
    
    var body: some View {
        Circle()
            .fill(Color.gray.opacity(0.2))
            .frame(width: 80, height: 80)
            .overlay(
                Image(imageAsset)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
            )
            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
    }
}

struct WelcomeSection: View {
    @Binding var showWelcomeText: Bool
    @Binding var showInstructions: Bool
    
    var body: some View {
        ZStack {
            // Welcome animation
            Text("Welcome to I Cook!")
                .font(.largeTitle.bold())
                .foregroundColor(AppTheme.textSecondary)
                .padding(.trailing, 50)
                .padding(.bottom, 180)
                .opacity(showWelcomeText ? 1 : 0)
                .offset(y: showWelcomeText ? 0 : -50)
                .animation(.easeInOut(duration: 1.5), value: showWelcomeText)
                .accessibilityLabel("Welcome to I Cook! A cooking app where you can insert your recipes and face challenges.")
            
            // Instructions animation
            Text("Insert your recipes\nand face your\nchallenges")
                .font(.title)
                .foregroundColor(AppTheme.textSecondary)
                .padding(.trailing, 140)
                .padding(.top, 230)
                .opacity(showInstructions ? 1 : 0)
                .animation(.easeInOut(duration: 1), value: showInstructions)
            
            // Mascot image
            Image("Mascotte3")
                .resizable()
                .scaledToFit()
                .frame(width: 500, height: 250)
                .padding(.leading, 200)
                .padding(.top, 100)
                .accessibilityLabel("A friendly mascot holding a cooking pan.")
        }
        .padding(.top, -50)
    }
}

struct AwardsSection: View {
    @Binding var isBadgesViewPresented: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header section
            HStack {
                Text("Awards")
                    .font(.title2.bold())
                    .foregroundColor(AppTheme.textPrimary)
                
                Spacer()
                
                Button(action: {
                    isBadgesViewPresented = true
                }) {
                    Text("See All")
                        .font(.headline)
                        .foregroundColor(AppTheme.textPrimary)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppTheme.cardColor)
            .cornerRadius(AppTheme.cornerRadius, corners: [.topLeft, .topRight])
            
            // Badges section
            HStack{
                Spacer()
                BadgeCircle(imageAsset: "badge1T")
                Spacer()
                BadgeCircle(imageAsset: "badge1F")
                Spacer()
                BadgeCircle(imageAsset: "badge1F")
                Spacer()
            }
            .padding(.vertical)
            .frame(maxWidth: .infinity)
            .background(AppTheme.cardColor)
            .cornerRadius(AppTheme.cornerRadius, corners: [.bottomLeft, .bottomRight])
        }
        .frame(width: 370)
        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Main View
struct ContentView: View {
    @StateObject private var recipeStore = RecipeStore()
    @State private var isBadgesViewPresented = false
    @State private var showWelcomeText = false
    @State private var showInstructions = false

    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: AppTheme.spacing) {
                    // Welcome section with animations and mascot
                    WelcomeSection(
                        showWelcomeText: $showWelcomeText,
                        showInstructions: $showInstructions
                    )
                    
                    Spacer()
                    
                    // Navigation cards
                    HStack(spacing: AppTheme.spacing) {
                        NavigationCard(
                            title: "Recipes",
                            destination: RecipiesView(),
                            imageAsset: "Mascotte2",
                            width: 170,
                            height: 200
                        )
                        
                        NavigationCard(
                            title: "Challenges",
                            destination: ChallengesView(),
                            imageAsset: "Mascotte2",
                            width: 170,
                            height: 200
                        )
                    }
                    
                    // Awards section
                    AwardsSection(isBadgesViewPresented: $isBadgesViewPresented)
                        .padding(.bottom, AppTheme.spacing)
                }
                .padding()
            }
            .sheet(isPresented: $isBadgesViewPresented) {
                BadgesView()
            }
            .onAppear {
                // Activate animations
                withAnimation {
                    showWelcomeText = true
                }
                
                // Delay showing instructions
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
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
