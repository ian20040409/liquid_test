//
//  LiquidDemoView.swift
//  liquid_test
//
//  Demo view showcasing all Liquid Water components
//

import SwiftUI

struct LiquidDemoView: View {
    @State private var toggleState = false
    @State private var progressValue: Double = 0.7
    @State private var textInput = ""
    @State private var showingDemo = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Animated liquid background
                LiquidBackgroundView(animateGradient: .constant(true))
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Header
                        VStack(spacing: 15) {
                            Text("Component Gallery")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(.top, 80)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.white, .cyan.opacity(0.8)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                            
                            Text("Interactive Liquid Water components")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.top, 20)
                        
                        // Wave Animation Demo
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Liquid Waves")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            LiquidWaveView()
                                .frame(height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(.white.opacity(0.2), lineWidth: 1)
                                )
                        }
                        .padding(.horizontal, 20)
                        
                        // Loading Animation Demo
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Liquid Loading")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            HStack {
                                Spacer()
                                LiquidLoadingView()
                                Spacer()
                            }
                            .padding(.vertical, 20)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                        }
                        .padding(.horizontal, 20)
                        
                        // Progress Bar Demo
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Liquid Progress")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Text("\(Int(progressValue * 100))%")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            
                            LiquidProgressBar(progress: progressValue)
                            
                            HStack {
                                Button("25%") { animateProgress(to: 0.25) }
                                Button("50%") { animateProgress(to: 0.5) }
                                Button("75%") { animateProgress(to: 0.75) }
                                Button("100%") { animateProgress(to: 1.0) }
                            }
                            .buttonStyle(MiniGlassButtonStyle())
                        }
                        .padding(20)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal, 20)
                        
                        // Toggle Demo
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Liquid Toggle")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            HStack {
                                Text("Enable liquid effects")
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Spacer()
                                
                                LiquidToggle(isOn: $toggleState)
                            }
                            .padding(20)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                        }
                        .padding(.horizontal, 20)
                        
                        // Text Field Demo
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Liquid Text Field")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            LiquidTextField(text: $textInput, placeholder: "Enter your text...")
                        }
                        .padding(.horizontal, 20)
                        
                        // Interactive Cards
                        VStack(spacing: 15) {
                            GlassCard(
                                title: "Morphing Surfaces",
                                description: "Watch surfaces transform with liquid-like fluidity",
                                icon: "water.waves",
                                gradientColors: [.blue, .teal]
                            )
                            
                            GlassCard(
                                title: "Particle Systems",
                                description: "Dynamic particles that respond to touch",
                                icon: "sparkles",
                                gradientColors: [.purple, .indigo]
                            )
                            
                            GlassCard(
                                title: "Fluid Animations",
                                description: "Smooth transitions that feel natural",
                                icon: "waveform.path.ecg",
                                gradientColors: [.green, .mint]
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        // Action Buttons
                        VStack(spacing: 15) {
                            LiquidButton(title: "Experience Demo", action: {
                                showingDemo = true
                                
                            }).padding(.bottom, 80)
                            
                            
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 50)
                    }
                }
            }
            .ignoresSafeArea()
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingDemo) {
            InteractiveDemoView()
        }
    }
    
    private func animateProgress(to value: Double) {
        withAnimation(.easeInOut(duration: 1.0)) {
            progressValue = value
        }
    }
    
    private func resetDemo() {
        withAnimation(.easeInOut(duration: 0.5)) {
            toggleState = false
            progressValue = 0.0
            textInput = ""
        }
    }
}

// MARK: - Interactive Demo View
struct InteractiveDemoView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var tapLocation: CGPoint = .zero
    @State private var showRipple = false
    @State private var rippleScale: CGFloat = 0
    
    var body: some View {
        ZStack {
            LiquidBackgroundView(animateGradient: .constant(true))
            
            VStack {
                HStack {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                    .padding()
                    
                    Spacer()
                }
                
                Spacer()
                
                VStack(spacing: 30) {
                    Text("Touch anywhere")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Experience liquid interactions")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
            }
            
            // Ripple effect
            if showRipple {
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.8), .clear],
                            startPoint: .center,
                            endPoint: .trailing
                        ),
                        lineWidth: 3
                    )
                    .frame(width: 100, height: 100)
                    .scaleEffect(rippleScale)
                    .opacity(1.0 - (rippleScale / 3.0))
                    .position(tapLocation)
                    .animation(.easeOut(duration: 1), value: rippleScale)
            }
        }
        .ignoresSafeArea()
        .onTapGesture { location in
            createRipple(at: location)
        }
    }
    
    private func createRipple(at location: CGPoint) {
        tapLocation = location
        showRipple = true
        rippleScale = 0
        
        withAnimation(.easeOut(duration: 1)) {
            rippleScale = 3
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            showRipple = false
        }
    }
}

// MARK: - Mini Glass Button Style
struct MiniGlassButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.caption)
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview {
    LiquidDemoView()
}
