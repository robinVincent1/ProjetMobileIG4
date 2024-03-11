//
//  ContentView.swift
//  ProjetMobileIG4
//
//  Created by Robin Vincent on 06/03/2024.
//

import SwiftUI

class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    private let tokenKey = "AuthToken"
    
    var authToken: String? {
        UserDefaults.standard.string(forKey: tokenKey)
    }
    
    func login(token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
        isAuthenticated = true
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
        isAuthenticated = false
        AuthenticationManager.shared.deleteTokenFromKeychain()
    }
}

struct ContentView: View {
    @StateObject private var authManager = AuthManager()
    
    var body: some View {
        if authManager.isAuthenticated {
            // Afficher le contenu protégé de l'application
            Text("Bienvenue dans votre application")
                .onTapGesture {
                    authManager.logout()
                }
        } else {
            // Afficher l'écran de connexion
            Login(authManager: authManager)
        }
    }
}


#Preview {
    ContentView()
}
