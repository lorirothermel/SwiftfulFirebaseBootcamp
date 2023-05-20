//
//  AuthenticationView.swift
//  SwiftfulFirebaseBootcamp
//
//  Created by Lori Rothermel on 5/17/23.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift


@MainActor
final class AuthenticationViewModel: ObservableObject {
        
    let signInAppleHelper = SignInAppleHelper()
    
    
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        try await AuthenicationManager.shared.signInWithGoogle(tokens: tokens)
    }  // signInGoogle

    func signInApple() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        try await AuthenicationManager.shared.signInWithApple(tokens: tokens)
    }  // signInApple
    
}  // class AuthenticationViewModel






struct AuthenticationView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
        
    
    
    var body: some View {
        VStack {
            NavigationLink {
                SignInEmailView(showSignInView: $showSignInView)
            } label: {
                Text("Sign In With Email")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .cornerRadius(10)
            }  // NavigationLink
            
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                Task {
                    do {
                        try await viewModel.signInGoogle()
                        showSignInView = false
                    } catch {
                        print("ERROR: \(error.localizedDescription)")
                    }  // do...catch
                }  // Task
            }  // GoogleSignInButton
            
            
//            SignInWithAppleButtonViewRepresentable(type: .default, style: .black)
//                .allowsHitTesting(false)
//                .frame(height: 55)
            
            Button {
                Task {
                    do {
                        try await viewModel.signInApple()
                        showSignInView = false
                    } catch {
                        print("ERROR: \(error.localizedDescription)")
                    }  // do...catch
                }  // Task
            } label: {
                SignInWithAppleButtonViewRepresentable(type: .default, style: .black)
                    .allowsHitTesting(false)
                    .frame(height: 55)
                    
            }  // Button

            
            Spacer()
            
        }  // VStack
        .navigationTitle("Sign In")
        .padding()
        
    }  // some View
}  // AuthenticationView


struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AuthenticationView(showSignInView: .constant(false))
        }  // NavigationStack
        
    }
}
