//
//  ContentView.swift
//  liquid_test
//
//  Created by Ian on 2025/7/7.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Main Home Tab
            MainHomeView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            // Demo Tab
            LiquidDemoView()
                .tabItem {
                    Image(systemName: "drop.fill")
                    Text("Demo")
                }
                .tag(1)
        }
        .accentColor(.cyan)
    }
}

// MARK: - Main Home View
struct MainHomeView: View {
    @Binding var selectedTab: Int
    @State private var animateGradient = false
    @State private var floatingOffset: CGFloat = 0
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        NavigationStack {
        ZStack {
            // Animated liquid background
            LiquidBackgroundView(animateGradient: $animateGradient)
            
            ScrollView {
                VStack(spacing: 30) {
                    // Header section
                    VStack(spacing: 20) {
                        // Floating logo with liquid effect
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.blue.opacity(0.3),
                                            Color.purple.opacity(0.2),
                                            Color.pink.opacity(0.3)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                                .blur(radius: 20)
                                .scaleEffect(pulseScale)
                            
                            Image(systemName: "drop.fill")
                                .font(.system(size: 50))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.blue, .cyan, .purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .offset(y: floatingOffset)
                        }
                        
                        Text("Liquid Water")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, .blue.opacity(0.8)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        
                        Text("Experience the future of design")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 50)
                    
                    // Glass cards section
                    VStack(spacing: 20) {
                        GlassCard(
                            title: "Fluid Interactions",
                            description: "Touch and feel the liquid responsiveness",
                            icon: "hand.tap.fill",
                            gradientColors: [.blue, .cyan]
                        )
                        
                        GlassCard(
                            title: "Dynamic Animations",
                            description: "Watch elements flow like liquid mercury",
                            icon: "waveform.path",
                            gradientColors: [.purple, .pink]
                        )
                        
                        GlassCard(
                            title: "Glass Morphism",
                            description: "Translucent surfaces with depth and beauty",
                            icon: "sparkles",
                            gradientColors: [.green, .mint]
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Interactive buttons
                    VStack(spacing: 15) {
                        LiquidButton(
                            title: "View Demo",
                            action: {
                                selectedTab = 1 // Switch to demo tab
                            },
                            style: .primary,
                            size: .medium,
                            icon: "drop.fill"
                        )
                        
                        
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 50)
                }
            }
            
            // Floating particles
            ForEach(0..<6, id: \.self) { index in
                FloatingParticle(index: index)
            }
        }
        .ignoresSafeArea()
        .toolbar(.hidden, for: .navigationBar)

        .onAppear {
            startAnimations()
        }
        }
    }
    
    private func startAnimations() {
        // Gradient animation
        withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
            animateGradient.toggle()
        }
        
        // Floating animation
        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
            floatingOffset = -10
        }
        
        // Pulse animation
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.1
        }
    }
}

// MARK: - Liquid Background View
struct LiquidBackgroundView: View {
    @Binding var animateGradient: Bool
    
    var body: some View {
        ZStack {
            // Base dark background
            Color.black
            
            // Animated gradient layers
            LinearGradient(
                colors: animateGradient ? 
                [Color.blue.opacity(0.6), Color.purple.opacity(0.4), Color.pink.opacity(0.3)] :
                [Color.purple.opacity(0.4), Color.blue.opacity(0.3), Color.cyan.opacity(0.5)],
                startPoint: animateGradient ? .topLeading : .bottomTrailing,
                endPoint: animateGradient ? .bottomTrailing : .topLeading
            )
            
            // Additional flowing layer
            RadialGradient(
                colors: [
                    Color.cyan.opacity(0.3),
                    Color.blue.opacity(0.2),
                    Color.clear
                ],
                center: animateGradient ? .topTrailing : .bottomLeading,
                startRadius: 50,
                endRadius: 400
            )
        }
    }
}

// MARK: - Glass Card Component
struct GlassCard: View {
    let title: String
    let description: String
    let icon: String
    let gradientColors: [Color]
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 15) {
                // Icon with gradient
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: gradientColors.map { $0.opacity(0.3) },
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundStyle(
                            LinearGradient(
                                colors: gradientColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "bubbles.and.sparkles.fill")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.3), .clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

// MARK: - Floating Particle Component
struct FloatingParticle: View {
    let index: Int
    @State private var offset = CGSize.zero
    @State private var opacity: Double = 0.3
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        particleColor.opacity(0.6),
                        particleColor.opacity(0.2),
                        .clear
                    ],
                    center: .center,
                    startRadius: 1,
                    endRadius: 15
                )
            )
            .frame(width: particleSize, height: particleSize)
            .offset(offset)
            .opacity(opacity)
            .onAppear {
                startFloating()
            }
    }
    
    private var particleColor: Color {
        switch index % 3 {
        case 0: return .blue
        case 1: return .purple
        default: return .cyan
        }
    }
    
    private var particleSize: CGFloat {
        CGFloat.random(in: 20...40)
    }
    
    private func startFloating() {
        let randomDelay = Double.random(in: 0...2)
        let randomDuration = Double.random(in: 3...6)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + randomDelay) {
            withAnimation(
                .easeInOut(duration: randomDuration)
                .repeatForever(autoreverses: true)
            ) {
                offset = CGSize(
                    width: CGFloat.random(in: -100...100),
                    height: CGFloat.random(in: -150...150)
                )
            }
            
            withAnimation(
                .easeInOut(duration: randomDuration * 0.7)
                .repeatForever(autoreverses: true)
            ) {
                opacity = Double.random(in: 0.1...0.6)
            }
        }
    }
}

#Preview {
    ContentView()
}
