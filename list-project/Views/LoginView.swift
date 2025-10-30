import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isAnimating = false
    @State private var showPassword = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.8), Color.purple.opacity(0.6)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 25) {
                // Animated logo
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 2)
                                .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                    
                    Image(systemName: "film")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                        .animation(
                            Animation.linear(duration: 20)
                                .repeatForever(autoreverses: false),
                            value: isAnimating
                        )
                }
                .padding(.top, 50)
                
                Text("FilmList")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Your Personal Movie Companion")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                
                // Login form
                VStack(spacing: 20) {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    HStack {
                        if showPassword {
                            TextField("Password", text: $password)
                        } else {
                            SecureField("Password", text: $password)
                        }
                        
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
                
                // Login button
                Button(action: {
                    // Handle login
                }) {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.purple)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 30)
                
                // Sign up link
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.white.opacity(0.8))
                    Button("Sign Up") {
                        // Handle sign up
                    }
                    .foregroundColor(.purple)
                }
                .padding(.top, 10)
                
                Spacer()
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    LoginView()
} 