//
//  AuthViewModel.swift
//  ProjetMobileIG4
//
//  Created by Robin Vincent on 12/03/2024.
//

import Foundation

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
