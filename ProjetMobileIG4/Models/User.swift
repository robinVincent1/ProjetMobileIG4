//
//  User.swift
//  ProjetMobileIG4
//
//  Created by Robin Vincent on 12/03/2024.
//

import Foundation

// Définition de la structure User conforme au modèle récupéré depuis l'API
struct User: Codable {
    let email: String
    let password: String
    let active: Bool
    let role: String
    let firstName: String
    let lastName: String
    let nbEdition: Int
    let pseudo: String?
    let postalAddress: String?
    let propo: String?
    let association: String?
    let telephone: String?
    let photoProfil: String?
    let idFestival: String?
    let flexible: Bool?
}

struct UserConnected : Codable {
    var id: Int
    var accessToken: String
}
