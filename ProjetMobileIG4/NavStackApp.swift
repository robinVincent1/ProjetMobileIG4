import SwiftUI

struct Navigation : View {
    @State private var path = [String]()
    
    var body : some View {
        NavigationStack(path: $path){
            List{
                NavigationLink("Test", value: "ABC")
                Button("Navigate to XYZ"){
                    path.append("XYZ")
                }
            }.navigationDestination(for: String.self){string in
                VStack{
                    Text(string)
                    Button("ABC"){
                        path.append("WXY")
                    }
                    Button("Pop to root"){
                        path.removeAll()
                    }
                }
            }
        }
    }
}
