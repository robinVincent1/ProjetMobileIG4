//
//  ContentView.swift
//  ProjetMobileIG4
//
//  Created by Robin Vincent on 06/03/2024.
//

import SwiftUI

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
