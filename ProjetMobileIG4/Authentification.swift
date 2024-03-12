// AuthenticationManager.swift

import Security
import SwiftUI

// Classe gérant l'authentification et la gestion du token d'authentification
class AuthenticationManager {
    
    // Singleton pour partager une instance unique de la classe dans toute l'application
    static let shared = AuthenticationManager()
    
    // Clé utilisée pour enregistrer et récupérer le token dans le trousseau d'accès
    private let tokenKey = "accessToken"
    
    // Constructeur privé pour empêcher l'initialisation directe de la classe
    private init() {}
    
    // Fonction pour enregistrer le token dans le trousseau d'accès
    func saveTokenToKeychain(token: String) {
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenKey,
            kSecValueData as String: token.data(using: .utf8)!,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        let status = SecItemAdd(keychainQuery as CFDictionary, nil)
        guard status == errSecSuccess else {
            print("Erreur lors de l'enregistrement du token dans le trousseau d'accès : \(status)")
            return
        }
        
        print("Token enregistré avec succès dans le trousseau d'accès.")
    }
    
    // Fonction pour récupérer le token depuis le trousseau d'accès
    func retrieveTokenFromKeychain() -> String? {
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenKey,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(keychainQuery as CFDictionary, &dataTypeRef)
        
        guard status == errSecSuccess, let data = dataTypeRef as? Data else {
            print("Erreur lors de la récupération du token depuis le trousseau d'accès : \(status)")
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    // fonction pour supprimer le token du trousseau
    func deleteTokenFromKeychain() {
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenKey
        ]

        let status = SecItemDelete(keychainQuery as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            print("Erreur lors de la suppression du token du trousseau d'accès : \(status)")
            return
        }

        print("Token supprimé avec succès du trousseau d'accès.")
    }

}
