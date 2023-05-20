//
//  SignInEmailView.swift
//  SwiftfulFirebaseBootcamp
//
//  Created by Lori Rothermel on 5/17/23.
//

import SwiftUI

@MainActor
final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found!")
            return
        }
                
            try await AuthenicationManager.shared.createUser(email: email, password: password)
                    
    }  // signUp
    
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found!")
            return
        }
        
        try await AuthenicationManager.shared.signInUser(email: email, password: password)
        
    }  // signIn
    
    
    
    
    
    
}  // SigninEmailViewModel


struct SignInEmailView: View {
    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    
    
    
    var body: some View {
        VStack {
            TextField("Email...", text: $viewModel.email)
                .padding()
                .background(.gray.opacity(0.4))
                .cornerRadius(10)
            
            SecureField("Password...", text: $viewModel.password)
                .padding()
                .background(.gray.opacity(0.4))
                .cornerRadius(10)
            
            Button {
                Task {
                    do {
                        try await viewModel.signUp()
                        showSignInView = false
                        return
                    } catch {
                        print("ERROR: \(error.localizedDescription)")
                    }
                                
                do {
                    try await viewModel.signIn()
                    showSignInView = false
                    return
                } catch {
                    print("ERROR: \(error.localizedDescription)")
                }
            }  // Task
                
                
                
            } label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .cornerRadius(10)
            }  // Button

            Spacer()
            
        }  // VStack
        .navigationTitle("Sign In With Email")
        .padding()
        
    }  // some View
}  // SignInEmailView


struct SignInEmailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignInEmailView(showSignInView: .constant(false))
        }  // NavigationStack
        
    }
}
