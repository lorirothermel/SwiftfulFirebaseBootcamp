//
//  SettingsView.swift
//  SwiftfulFirebaseBootcamp
//
//  Created by Lori Rothermel on 5/17/23.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var authProviders: [AuthProviderOption] = []
    
    
    func loadAuthProviders() {
        if let provider = try? AuthenicationManager.shared.getProviders() {
            authProviders = provider
        }
        
    }
    
    
    func signOut() throws {
        try AuthenicationManager.shared.signOut()
    }
    
    
    func resetPassword() async throws {
        let authUser = try AuthenicationManager.shared.getAuthenicatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
                
        try await AuthenicationManager.shared.resetPassword(email: email)
        
    }
    
    
    func updateEmail() async throws {
        let authUser = try AuthenicationManager.shared.getAuthenicatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
                
        try await AuthenicationManager.shared.updateEmail(email: email)
    }
    
    
    func updatePassword() async throws {
        let password = "Winston7"
            
        try await AuthenicationManager.shared.updatePassword(password: password)
    }
    
}




struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    
    
    var body: some View {
        List {
            Button {
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print("ERROR: \(error.localizedDescription)")
                    }  // do...catch
                }  // Task
            } label: {
                Text("Logout")
            }  // Button
            .buttonStyle(.borderedProminent)
            
            if viewModel.authProviders.contains(.email) {
                emailSection
            }
            
            
            
        }  // List
        .onAppear {
            viewModel.loadAuthProviders()
        }
        .navigationTitle("Settings")
    }  // some View
}  // SettingsView


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView(showSignInView: .constant(false))
        }
        
    }
}

extension SettingsView {
    
    private var emailSection: some View {
        
        Section {
            Button {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("PASSWORD RESET!")
                    } catch {
                        print("ERROR: \(error.localizedDescription)")
                    }  // do...catch
                }  // Task
            } label: {
                Text("Reset Password")
            }  // Button
            .buttonStyle(.borderedProminent)
            
            Button {
                Task {
                    do {
                        try await viewModel.updatePassword()
                        print("UPDATED THE PASSWORD!")
                    } catch {
                        print("ERROR: \(error.localizedDescription)")
                    }  // do...catch
                }  // Task
            } label: {
                Text("Update Password")
            }  // Button
            .buttonStyle(.borderedProminent)
            
            Button {
                Task {
                    do {
                        try await viewModel.updateEmail()
                        print("UPDATED THE EMAIL!")
                    } catch {
                        print("ERROR: \(error.localizedDescription)")
                    }  // do...catch
                }  // Task
            } label: {
                Text("Update Email")
            }  // Button
            .buttonStyle(.borderedProminent)
        } header: {
            Text("Email Functions")
        }  // Section
    }  // some View
}  // extension SettingsView

