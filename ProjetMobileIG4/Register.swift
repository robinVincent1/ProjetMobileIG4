import SwiftUI



struct Register: View {
    
    //gerer la connexion
    @ObservedObject var authManager: AuthManager
    
    // Variables d'état pour les champs de saisie de l'inscription
    @State private var pseudo = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var email = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var telephone = ""
    
    // Variable d'état pour afficher une alerte en cas d'erreur d'inscription
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var user : UserConnected? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.blue
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white)
                
                VStack {
                    Text("Inscription")
                        .font(.largeTitle)
                        .bold()
                    
                    
                    // Champ de saisie pour le prénom et le nom de famille sur la même ligne
                    HStack {
                        TextField("Prénom", text: $firstName)
                            .padding()
                            .frame(width: 150, height: 50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                        
                        TextField("Nom de famille", text: $lastName)
                            .padding()
                            .frame(width: 150, height: 50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                    }
                    
                    // Champ de saisie pour l'identifiant et le téléphone sur la même ligne
                    HStack {
                        TextField("Pseudo", text: $pseudo)
                            .padding()
                            .frame(width: 150, height: 50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                        
                        TextField("Téléphone", text: $telephone)
                            .padding()
                            .frame(width: 150, height: 50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                    }
                    
                    // Champ de saisie pour l'email
                    TextField("Email", text: $email)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                    
                    // Champ de saisie sécurisé pour le mot de passe
                    SecureField("Mot de passe", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                    
                    // Champ de saisie sécurisé pour la confirmation du mot de passe
                    SecureField("Confirmer le mot de passe", text: $confirmPassword)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                    
                    // Bouton d'inscription
                    Button("S'inscrire") {
                        // Ajouter ici la logique d'inscription
                    }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                    
                    // Bouton pour aller sur la page de connexion
                    Button("Déjà inscrit ?") {
                        registerUser()
                    }
                    .foregroundColor(.blue)
                    .padding(.top, 10)
                }
            }
        }
    }
    // Fonction pour envoyer les données d'inscription à l'API
    func registerUser() {
        // Vérification des champs obligatoires
        guard !pseudo.isEmpty, !password.isEmpty, !confirmPassword.isEmpty, !email.isEmpty else {
            // Gérer l'erreur
            return
        }
        
        // Vérification de la correspondance des mots de passe
        guard password == confirmPassword else {
            // Gérer l'erreur
            return
        }
        
        // Création de l'objet utilisateur
        let newUser = User(
            email: email,
            password: password,
            active: true,
            role: "Bénévole",
            firstName: firstName,
            lastName: lastName,
            nbEdition: 0,
            pseudo: pseudo,
            postalAddress: nil,
            propo: nil,
            association: nil,
            telephone: telephone,
            photoProfil: nil,
            idFestival: nil,
            flexible: nil
        )
        
        // Encodage de l'utilisateur en JSON
        guard let encodedUser = try? JSONEncoder().encode(newUser) else {
            // Gérer l'erreur
            return
        }
        
        // Envoi des données à l'API
        guard let url = URL(string: "http://localhost:8080/user") else {
            // Gérer l'erreur
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = encodedUser
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                // Gérer l'erreur
                return
            }
            
            // Vérifier la réponse de l'API et effectuer les actions nécessaires
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(UserConnected.self, from: data)
                    DispatchQueue.main.async {
                        self.user = decodedResponse
                        let token = decodedResponse.accessToken
                        
                        //sauvergarder le token
                        AuthenticationManager.shared.saveTokenToKeychain(token: token)
                        
                        //se loger avec le token
                        authManager.login(token: token)
                        
                    }
                } catch {
                    // Gérer l'erreur de désérialisation
                    print("Erreur lors de la désérialisation de la réponse JSON : \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}
    // Structure pour le modèle de réponse de l'API (à adapter selon le format de réponse de votre API)
    struct Response: Decodable {
        // Propriétés de réponse de votre API
    }
