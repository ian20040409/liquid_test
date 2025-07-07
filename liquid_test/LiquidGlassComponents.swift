//
//  LiquidGlassComponents.swift
//  liquid_test
//
//  Advanced Liquid Water components and effects
//

import SwiftUI

// MARK: - Liquid Wave Animation
struct LiquidWaveView: View {
    @State private var waveOffset: CGFloat = 0
    @State private var waveOffset2: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Simplified wave effect using rectangles
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.blue.opacity(0.4),
                            Color.cyan.opacity(0.2)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .mask(
                    Rectangle()
                        .offset(x: waveOffset)
                )
                .animation(
                    .linear(duration: 3).repeatForever(autoreverses: false),
                    value: waveOffset
                )
            
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.purple.opacity(0.3),
                            Color.pink.opacity(0.2)
                        ],
                        startPoint: .trailing,
                        endPoint: .leading
                    )
                )
                .mask(
                    Rectangle()
                        .offset(x: waveOffset2)
                )
                .animation(
                    .linear(duration: 4).repeatForever(autoreverses: false),
                    value: waveOffset2
                )
        }
        .onAppear {
            waveOffset = 100
            waveOffset2 = -100
        }
    }
}

// MARK: - Liquid Loading Animation
struct LiquidLoadingView: View {
    @State private var isAnimating = false
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            // Outer ring
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.blue.opacity(0.3),
                            Color.purple.opacity(0.6),
                            Color.pink.opacity(0.3)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 4
                )
                .frame(width: 60, height: 60)
                .rotationEffect(.degrees(rotationAngle))
            
            // Inner liquid drops
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                dropColor(for: index).opacity(0.8),
                                dropColor(for: index).opacity(0.3)
                            ],
                            center: .center,
                            startRadius: 2,
                            endRadius: 8
                        )
                    )
                    .frame(width: 12, height: 12)
                    .offset(
                        x: isAnimating ? cos(Double(index) * 2 * Double.pi / 3) * 20 : 0,
                        y: isAnimating ? sin(Double(index) * 2 * Double.pi / 3) * 20 : 0
                    )
                    .animation(
                        .easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.2),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            isAnimating = true
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
        }
    }
    
    private func dropColor(for index: Int) -> Color {
        switch index {
        case 0: return .blue
        case 1: return .purple
        default: return .cyan
        }
    }
}

// MARK: - Liquid Progress Bar
struct LiquidProgressBar: View {
    let progress: Double
    @State private var animatedProgress: Double = 0
    @State private var waveOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: 15)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.2), .clear],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                lineWidth: 1
                            )
                    )
                
                // Liquid fill with simplified effect
                RoundedRectangle(cornerRadius: 15)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.blue.opacity(0.8),
                                Color.cyan.opacity(0.6),
                                Color.purple.opacity(0.4)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * animatedProgress)
                    .animation(.easeInOut(duration: 1), value: animatedProgress)
                
                // Shimmer effect
                RoundedRectangle(cornerRadius: 15)
                    .fill(
                        LinearGradient(
                            colors: [
                                .clear,
                                .white.opacity(0.3),
                                .clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * animatedProgress)
                    .offset(x: waveOffset * 2)
            }
        }
        .frame(height: 30)
        .onAppear {
            animatedProgress = progress
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                waveOffset = 100
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(.easeInOut(duration: 0.8)) {
                animatedProgress = newValue
            }
        }
    }
}

// Simplified wave mask - removed to avoid Shape conformance issues

// MARK: - Enhanced Liquid Button Component
struct LiquidButton: View {
    // MARK: - Properties
    let title: String
    let action: () -> Void
    var style: LiquidButtonStyle = .primary
    var size: LiquidButtonSize = .medium
    var icon: String? = nil
    var isEnabled: Bool = true
    
    // MARK: - Animation States
    @State private var isPressed = false
    @State private var isHovered = false
    @State private var shimmerOffset: CGFloat = -200
    @State private var pulseScale: CGFloat = 1.0
    @State private var liquidFlow: CGFloat = 0
    @State private var glowIntensity: Double = 0.3
    
    // MARK: - Style Definitions
    enum LiquidButtonStyle {
        case primary
        case secondary
        case accent
        case destructive
        case ghost
        
        var gradientColors: [Color] {
            switch self {
            case .primary:
                return [.blue, .purple, .pink]
            case .secondary:
                return [.gray.opacity(0.6), .blue.opacity(0.4)]
            case .accent:
                return [.cyan, .teal, .mint]
            case .destructive:
                return [.red, .orange, .pink]
            case .ghost:
                return [.clear]
            }
        }
        
        var textColor: Color {
            switch self {
            case .primary, .accent, .destructive:
                return .white
            case .secondary:
                return .blue
            case .ghost:
                return .white.opacity(0.9)
            }
        }
        
        var borderColors: [Color] {
            switch self {
            case .primary:
                return [.white.opacity(0.4), .white.opacity(0.1)]
            case .secondary:
                return [.blue.opacity(0.6), .purple.opacity(0.3)]
            case .accent:
                return [.cyan.opacity(0.6), .mint.opacity(0.3)]
            case .destructive:
                return [.red.opacity(0.6), .orange.opacity(0.3)]
            case .ghost:
                return [.white.opacity(0.3), .white.opacity(0.1)]
            }
        }
        
        var shadowColor: Color {
            switch self {
            case .primary:
                return .blue
            case .secondary:
                return .gray
            case .accent:
                return .cyan
            case .destructive:
                return .red
            case .ghost:
                return .white
            }
        }
    }
    
    enum LiquidButtonSize {
        case small, medium, large
        
        var padding: EdgeInsets {
            switch self {
            case .small:
                return EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
            case .medium:
                return EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24)
            case .large:
                return EdgeInsets(top: 16, leading: 32, bottom: 16, trailing: 32)
            }
        }
        
        var font: Font {
            switch self {
            case .small:
                return .subheadline
            case .medium:
                return .headline
            case .large:
                return .title2
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            case .small:
                return 16
            case .medium:
                return 20
            case .large:
                return 24
            }
        }
        
        var iconSize: CGFloat {
            switch self {
            case .small:
                return 14
            case .medium:
                return 16
            case .large:
                return 20
            }
        }
    }
    
    // MARK: - Body
    var body: some View {
        Button(action: {
            if isEnabled {
                // Haptic feedback
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                
                // Trigger liquid flow animation
                withAnimation(.easeOut(duration: 0.6)) {
                    liquidFlow = 1.0
                    glowIntensity = 0.8
                }
                
                // Reset after animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    liquidFlow = 0
                    glowIntensity = 0.3
                }
                
                action()
            }
        }) {
            HStack(spacing: 8) {
                // Optional icon
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: size.iconSize, weight: .semibold))
                        .foregroundColor(style.textColor)
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
                }
                
                Text(title)
                    .font(size.font)
                    .fontWeight(.semibold)
                    .foregroundColor(style.textColor)
            }
            .padding(size.padding)
            .background(
                ZStack {
                    // Base glass background
                    RoundedRectangle(cornerRadius: size.cornerRadius)
                        .fill(.ultraThinMaterial)
                    
                    // Gradient overlay
                    RoundedRectangle(cornerRadius: size.cornerRadius)
                        .fill(
                            LinearGradient(
                                colors: style.gradientColors.map { $0.opacity(0.8) },
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    // Liquid flow effect
                    if liquidFlow > 0 {
                        RoundedRectangle(cornerRadius: size.cornerRadius)
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Color.white.opacity(0.6),
                                        Color.white.opacity(0.2),
                                        Color.clear
                                    ],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 100 * liquidFlow
                                )
                            )
                            .scaleEffect(liquidFlow)
                    }
                    
                    // Shimmer effect on hover/press
                    if isPressed || isHovered {
                        RoundedRectangle(cornerRadius: size.cornerRadius)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .clear,
                                        .white.opacity(0.4),
                                        .clear
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .offset(x: shimmerOffset)
                    }
                    
                    // Border glow
                    RoundedRectangle(cornerRadius: size.cornerRadius)
                        .stroke(
                            LinearGradient(
                                colors: style.borderColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: isPressed ? 3 : 2
                        )
                        .opacity(isEnabled ? 1.0 : 0.5)
                    
                    // Outer glow effect
                    RoundedRectangle(cornerRadius: size.cornerRadius)
                        .stroke(
                            style.shadowColor.opacity(glowIntensity),
                            lineWidth: 4
                        )
                        .blur(radius: 8)
                        .opacity(isPressed || isHovered ? 1.0 : 0.0)
                }
            )
            .scaleEffect(isPressed ? 0.95 : (isHovered ? 1.02 : 1.0))
            .scaleEffect(pulseScale)
            .opacity(isEnabled ? 1.0 : 0.6)
            .shadow(
                color: style.shadowColor.opacity(isPressed ? 0.4 : 0.2),
                radius: isPressed ? 8 : 4,
                x: 0,
                y: isPressed ? 2 : 4
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isEnabled)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                isPressed = pressing
            }
            
            if pressing {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    shimmerOffset = 200
                }
            } else {
                shimmerOffset = -200
            }
        }, perform: {})
        .onHover { hovering in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                isHovered = hovering
            }
            
            if hovering {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    shimmerOffset = 200
                }
            } else {
                shimmerOffset = -200
            }
        }
        .onAppear {
            // Start subtle pulse animation
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                pulseScale = 1.01
            }
        }
    }
}

// MARK: - Liquid Toggle Switch
struct LiquidToggle: View {
    @Binding var isOn: Bool
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging = false
    
    private let toggleWidth: CGFloat = 60
    private let toggleHeight: CGFloat = 32
    private let knobSize: CGFloat = 24
    
    var body: some View {
        ZStack {
            // Background track
            RoundedRectangle(cornerRadius: toggleHeight / 2)
                .fill(
                    LinearGradient(
                        colors: isOn ? 
                        [Color.blue.opacity(0.6), Color.purple.opacity(0.4)] :
                        [Color.gray.opacity(0.3), Color.gray.opacity(0.2)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: toggleHeight / 2)
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.2), .clear],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 1
                        )
                )
                .frame(width: toggleWidth, height: toggleHeight)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: toggleHeight / 2))
            
            // Liquid knob
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(0.9),
                            Color.white.opacity(0.7)
                        ],
                        center: .topLeading,
                        startRadius: 2,
                        endRadius: knobSize / 2
                    )
                )
                .frame(width: knobSize, height: knobSize)
                .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 1)
                .offset(x: knobOffset)
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isOn)
                .animation(.spring(response: 0.3, dampingFraction: 0.9), value: dragOffset)
                .scaleEffect(isDragging ? 1.1 : 1.0)
                .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isDragging)
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                isOn.toggle()
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    isDragging = true
                    dragOffset = value.translation.width
                }
                .onEnded { value in
                    isDragging = false
                    dragOffset = 0
                    
                    let threshold: CGFloat = toggleWidth / 4
                    if abs(value.translation.width) > threshold {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            isOn = value.translation.width > 0
                        }
                    }
                }
        )
    }
    
    private var knobOffset: CGFloat {
        let baseOffset = isOn ? (toggleWidth - knobSize) / 2 : -(toggleWidth - knobSize) / 2
        return baseOffset + (isDragging ? dragOffset * 0.5 : 0)
    }
}

// MARK: - Liquid Text Field
struct LiquidTextField: View {
    @Binding var text: String
    let placeholder: String
    @State private var isFocused = false
    @State private var shimmerOffset: CGFloat = -200
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: 15)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(
                                LinearGradient(
                                    colors: isFocused ? 
                                    [Color.blue.opacity(0.6), Color.purple.opacity(0.4)] :
                                    [Color.white.opacity(0.2), Color.clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: isFocused ? 2 : 1
                            )
                    )
                    .frame(height: 50)
                
                // Shimmer effect when focused
                if isFocused {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(
                            LinearGradient(
                                colors: [
                                    .clear,
                                    .white.opacity(0.3),
                                    .clear
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 50)
                        .offset(x: shimmerOffset)
                        .animation(
                            .linear(duration: 1.5).repeatForever(autoreverses: false),
                            value: shimmerOffset
                        )
                }
                
                // Text field
                HStack {
                    TextField(placeholder, text: $text)
                        .foregroundColor(.white)
                        .font(.body)
                        .onTapGesture {
                            isFocused = true
                        }
                    
                    if !text.isEmpty {
                        Button(action: { text = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .onAppear {
            if isFocused {
                shimmerOffset = 200
            }
        }
        .onChange(of: isFocused) { _, focused in
            if focused {
                shimmerOffset = 200
            }
        }
    }
}
