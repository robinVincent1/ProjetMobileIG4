import SwiftUI

struct Navigation : View {
    @State private var path = [String]()
    
    var body : some View {
        NavigationStack(path: $path){
        Zstack{
        Text("Test 🚘)
        }
        }
    }
}
