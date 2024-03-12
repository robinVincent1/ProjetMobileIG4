import SwiftUI
import Security


// Vue SwiftUI pour l'écran de connexion
struct Login: View {
    //gerer la connexion
    @ObservedObject var authManager: AuthManager
    
    // Variables d'état pour les identifiants de connexion et les erreurs
    @State private var email = ""
    @State private var password = ""
    @State private var wrongUsername: CGFloat = 0
    @State private var wrongPassword: CGFloat = 0
    @State private var showingLoginScreen = false

    
    // Stockage de l'utilisateur actuellement connecté
    @State private var user: UserConnected? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                // Fond de la vue
                Color.blue
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white)
                
                // Contenu de la vue
                VStack {
                    Text("Connexion")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    
                    // Champ de saisie pour l'identifiant
                    TextField("Identifiant", text: $email)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(Color.red, width: wrongUsername)
                    
                    // Champ de saisie sécurisé pour le mot de passe
                    SecureField("Mot de passe", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(Color.red, width: wrongPassword)
                    
                    // Bouton de connexion
                    Button("Connexion") {
                        authenticateUser(email: email, password: password)
                    }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                    
                    // Lien de navigation vers la vue après connexion
                    NavigationLink(destination: Text("Vous êtes connecté @\(email)"), isActive: $showingLoginScreen) {
                        EmptyView()
                    }
                    
                    // Bouton pour aller vers la page d'inscription
                    Button("Pas encore inscrit ?") {

                    }
                    .foregroundColor(.blue)
                    .padding()
                }
            }
        }
    }
    
    // Fonction pour authentifier l'utilisateur en utilisant les informations fournies
    func authenticateUser(email: String, password: String) {
        fetchFromAPI()
    }
    
    // Fonction pour récupérer les données de l'API
    func fetchFromAPI() {
        guard let url = URL(string: "http://localhost:8080/user/login") else {
            return
        }
        
        // Création des données JSON à envoyer
        let userData = [
            "email": email,
            "password": password
        ]
        
        do {
            // Encodage des données JSON
            let jsonData = try JSONSerialization.data(withJSONObject: userData, options: [])
            
            // Création de la requête URLRequest avec la méthode POST
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            // Création de la session URLSession et envoi de la requête
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("Erreur lors de la récupération des données : \(error?.localizedDescription ?? "Erreur inconnue")")
                    return
                }
                
                do {
                    // Désérialisation des données JSON en un objet UserConnected
                    let decodedData = try JSONDecoder().decode(UserConnected.self, from: data)
                    DispatchQueue.main.async {
                        self.user = decodedData
                        // Vérification des informations de connexion ici
                        if self.user != nil {
                            self.wrongUsername = 0
                            self.wrongPassword = 0
                            self.showingLoginScreen = true
                            
                            //sauvegarder le token
                            let token = decodedData.accessToken
                            AuthenticationManager.shared.saveTokenToKeychain(token: token)
                            
                            //se loger avec le token
                            authManager.login(token: decodedData.accessToken)
                        } else {
                            self.wrongUsername = 2
                        }
                    }
                } catch {
                    print("Erreur lors de la désérialisation de la réponse JSON : \(error.localizedDescription)")
                }
            }.resume()
        } catch {
            print("Erreur lors de la création des données JSON : \(error.localizedDescription)")
        }
    }

}

