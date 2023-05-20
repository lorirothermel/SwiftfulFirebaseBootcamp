//
//  RootView.swift
//  SwiftfulFirebaseBootcamp
//
//  Created by Lori Rothermel on 5/17/23.
//

import SwiftUI

struct RootView: View {
    @State private var showSignInView: Bool = false
    
    
    
    var body: some View {
        ZStack {
            
                if !showSignInView {
                    NavigationStack {
                        SettingsView(showSignInView: $showSignInView)
                    }  // NavigationStack
                }  // if
        }  // ZStack
        .onAppear {
            let authUser = try? AuthenicationManager.shared.getAuthenicatedUser()
            self.showSignInView = authUser == nil
        }  // .onAppear
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }  // NavigationStack
        }  // .fullScreenCover
    }  // some View
}  // RootView

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
