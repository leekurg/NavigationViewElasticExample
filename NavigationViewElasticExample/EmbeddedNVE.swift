//
//  EmbeddedNVE.swift
//  NavigationViewElasticExample
//
//  Created by Илья Аникин on 31.10.2024.
//

import NavigationViewElastic
import SwiftUI

struct EmbeddedNVEView: View {
    @State var path = NavigationPath()

    var body: some View {
        NavigationViewElastic(path: $path) {
            Color.blue.opacity(0.3)
                .frame(height: UIScreen.main.bounds.height - 100)
                .overlay(alignment: .top) {
                    description
                        .padding(.top, 50)
                }
                .overlay {
                    Button("To second screen") {
                        path.append(Route.Depth1())
                    }
                    .buttonStyle(.bordered)
                }
                .nveTitle("First")
                .navigationDestination(for: Route.Depth1.self) { _ in
                    Second(path: $path)
                }
        }
        .nveConfig { config in
            config.barCollapsedStyle = AnyShapeStyle(.ultraThinMaterial)
        }
        .tint(.purple)
    }
    
    var description: some View {
        HStack(alignment: .top) {
            Image(systemName: "sparkles")
                .font(.system(size: 40, weight: .bold))
                .foregroundStyle(.purple)
            
            Text("""
            This example demonstrates seamless navigation
            with 
            """)
            +
            Text("NavigationViewElastic")
                .foregroundColor(.purple)
                .fontWeight(.bold)
            +
            Text(" and other views within one navigation sequence"
                
            )
        }
        .font(.system(size: 20, weight: .semibold, design: .rounded))
        .padding(.horizontal, 40)
    }
}

//// MARK: - Second
struct Second: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        Color.brown.opacity(0.5)
            .frame(height: UIScreen.main.bounds.height - 200)
            .overlay {
                Button("To third screen") {
                    path.append(Route.Depth3())
                }
                .buttonStyle(.bordered)
            }
            .padding(.top, 10)
            .nveTitle("Second(NVE)")
            .nveSubtitle {
                subtitle
            }
            .nveToolbar {
                Toolbar.Item(placement: .leading) {
                    NVE.BackButton {
                        path.removeLast()
                    }
                }
                
                Toolbar.Item(placement: .trailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "heart")
                            .fontWeight(.bold)
                    }
                    .padding(5)
                }
            }
            .toolbar(.hidden, for: .navigationBar)  //important
    }
    
    var subtitle: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(1...6, id: \.self) { index in
                    Text("\(index)")
                        .padding(.horizontal, 30)
                        .padding(.vertical, 5)
                        .background(.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(.horizontal, 10)
        }
        .padding(.vertical, 5)
    }
}
//
//// MARK: - NVE 3
//struct NVE3: View {
//    @Binding var path: NavigationPath
//    
//    var body: some View {
//        NavigationViewElastic {
//            Color.green.opacity(0.5)
//                .frame(height: UIScreen.main.bounds.height - 200)
//                .overlay {
//                    Button("To fourth screen") {
//                        path.append(Route.Depth4())
//                    }
//                    .buttonStyle(.bordered)
//                }
//                .padding(.top, 10)
//                .nveTitle("Third(NVE)")
//        } leadingBarItem: {
//            leadingBar
//        } trailingBarItem: {
//            trailingBar
//        }
//        .toolbar(.hidden, for: .navigationBar)  //important
//        .navigationDestination(for: Route.Depth4.self) { _ in
//            Regular4(path: $path)
//        }
//    }
//    
//    var leadingBar: some View {
//        NVE.BackButton {
//            path.removeLast()
//        }
//    }
//    
//    var trailingBar: some View {
//        Button {
//            
//        } label: {
//            Image(systemName: "gear")
//                .fontWeight(.bold)
//        }
//        .padding(5)
//    }
//}
//
//// MARK: - Regular 4
//struct Regular4: View {
//    @Binding var path: NavigationPath
//    
//    var body: some View {
//        ScrollView(.vertical, showsIndicators: false) {
//            Color.blue.opacity(0.3)
//                .frame(height: UIScreen.main.bounds.height - 100)
//                .overlay {
//                    Button("Pop to root") {
//                        path = NavigationPath()
//                    }
//                    .buttonStyle(.bordered)
//                    .tint(.red)
//                }
//        }
//        .navigationTitle("Fourth(system)")
//        .navigationBarTitleDisplayMode(.large)
//    }
//}

enum Route {
    struct Depth1: Hashable { }
    struct Depth2: Hashable { }
    struct Depth3: Hashable { }
    struct Depth4: Hashable { }
}

/// Fix.
/// To be able to use *swipe-back* gesture, while ``NavigationStack`` back button is hidden,
/// you need to implement this extension.
/// All thanks goes to https://stackoverflow.com/a/68650943
extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}

#Preview {
    EmbeddedNVEView()
}
