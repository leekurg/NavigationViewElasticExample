//
//  ContentView.swift
//  NavigationViewElasticExample
//
//  Created by Илья Аникин on 20.07.2023.
//

import SwiftUI
import NavigationViewElastic

struct ContentView: View {
    @State var stopRefreshing = false

    var body: some View {
        TabView {
            nve
                .tabItem {
                    Label("NVE", systemImage: "rectangle.portrait.tophalf.filled")
                }

            system
                .tabItem {
                    Label("System", systemImage: "gear")
                }

            systemBack
                .tabItem {
                    Label("Back", systemImage: "chevron.left")
                }
        }
    }

    var nve: some View {
        NavigationViewElastic(
            content: {
                SpacerFixed(10)

                LazyVStack {
                    ForEach(1...20, id: \.self) { value in
                        SampleCard(title: "\(value)")
                    }
                }
                .nveTitle("Title")
                .nveTitleDisplayMode(.inline)
                .padding(.horizontal, 10)
            },
            subtitleContent: {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 5) {
                        ForEach(Product.allCases, id: \.self) { entry in
                            Button(action: { stopRefreshing = true }) {
                                Text(entry.rawValue)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                }
                .padding(.bottom, 10)
            },
            leadingBarItem: { NVE.BackButton() },
            trailingBarItem: {
                Button {
                } label: {
                    Image(systemName: "heart")
                        .font(.system(size: 20, weight: .bold))
                        .padding(.trailing, 10)
                }
            }
        )
        .refreshable(stopRefreshing: $stopRefreshing, onRefresh: {})
        .preferredColorScheme(.dark)
        .nveBarStyle(.ultraThinMaterial)
        .background(Color(white: 0.12))
    }

    var system: some View {
        SystemNavBar()
    }

    var systemBack: some View {
        SystemNavBarBackButton()
    }
}

extension ContentView {
    enum Product: String, CaseIterable {
        case all = "All"
        case cake = "Cake"
        case lemon = "Lemon"
        case broccoli = "Broccoli"
        case milk = "Milk"
        case sausages = "Sausages"
        case icecream = "Ice cream"
    }
}

struct SystemNavBar: View {
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(1...20, id: \.self) { value in
                        NavigationLink {
                            ScrollView {
                                Color.indigo
                                    .frame(height: UIScreen.main.bounds.height)
                                    .overlay {
                                        Text("Details of \(value)")
                                            .foregroundStyle(.white)
                                    }
                            }
                        } label: {
                            SampleCard(title: "\(value)")
                                .foregroundStyle(.white)
                        }

                    }
                }
                .padding(.horizontal, 10)
                .padding(.top, 10)
            }
            .navigationTitle("Title")
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                try? await Task.sleep(nanoseconds: 3 * 1_000_000_000)
            }
        }
    }
}

struct SystemNavBarBackButton: View {
    @State var isLinkActivated = false

    var body: some View {
        NavigationView {
            NavigationLink(
                isActive: $isLinkActivated,
                destination: { destination }
            ) {
                Text("Go to NVE")
            }
            .onAppear {
                isLinkActivated.toggle()
            }
        }
    }

    var destination: some View {
        NavigationViewElastic(
            content: {
                LazyVStack {
                    ForEach(1...20, id: \.self) { value in
                        SampleCard(title: "\(value)")
                            .paddingWhen(.top, 10) { value == 1 }
                    }
                }
                .padding(.horizontal, 10)
            },
            leadingBarItem: { NVE.BackButton() }
        )
        .navigationBarHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)

        SystemNavBar().previewDisplayName("System")

        SystemNavBarBackButton().previewDisplayName("Back button")
    }
}
