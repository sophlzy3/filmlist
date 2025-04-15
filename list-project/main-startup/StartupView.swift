//
//  File.swift
//  list-project
//
//  Created by Sophie Liu on 2025-04-14.
//

import SwiftUI

struct StartupView: View {
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @State private var isAnimating = false
    @State private var showMainContent = false
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging = false
    
    var body: some View {
        Group {
            if showMainContent {
                Main()
            } else {
                ZStack {
                    Color(.systemBackground)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        Text("Welcome to this app!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .scaleEffect(isAnimating ? 1.0 : 0.5)
                            .opacity(isAnimating ? 1.0 : 0.0)
                        
                        Image(systemName: "sparkles")
                            .font(.system(size: 60))
                            .foregroundColor(.accentColor)
                            .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    }
                    
                    // Swipe up indicator
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            VStack(spacing: 8) {
                                Image(systemName: "chevron.up")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.secondary)
                                Text("Swipe up to continue")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                            .opacity(isAnimating ? 1.0 : 0.0)
                            .offset(y: isDragging ? -20 : 0)
                            .animation(.easeInOut(duration: 0.3), value: isDragging)
                            Spacer()
                        }
                        .padding(.bottom, 30)
                    }
                }
                .offset(y: dragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            isDragging = true
                            if gesture.translation.height < 0 {
                                dragOffset = gesture.translation.height
                            }
                        }
                        .onEnded { gesture in
                            isDragging = false
                            if gesture.translation.height < -100 {
                                withAnimation(.spring()) {
                                    showMainContent = true
                                    isFirstLaunch = false
                                }
                            } else {
                                withAnimation(.spring()) {
                                    dragOffset = 0
                                }
                            }
                        }
                )
                .onAppear {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        isAnimating = true
                    }
                }
            }
        }
    }
}

struct StartupView_Previews: PreviewProvider {
    static var previews: some View {
        StartupView()
    }
} 
