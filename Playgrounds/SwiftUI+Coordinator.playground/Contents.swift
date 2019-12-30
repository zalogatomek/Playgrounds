import PlaygroundSupport
import SwiftUI

// MARK: - Views (Screens)

struct FirstView: View {
    @Binding var coordinationLink: FirstViewCoordinationLink?
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.red)
            
            Button("Go to Second View") {
                self.coordinationLink = .secondView
            }
        }
        .navigationBarTitle("First View")
    }
}

struct SecondView: View {
    @Binding var coordinationLink: SecondViewCoordinationLink?
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.green)
            
            Button("Go to Third View") {
                self.coordinationLink = .thirdView
            }
        }
        .navigationBarTitle("Second View")
    }
}

struct ThirdView: View {
    @Binding var coordinationLink: ThirdViewCoordinationLink?
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.blue)
        }
        .navigationBarTitle("ThirdView View")
    }
}

// MARK: - Coordinators

protocol CoordinationLink: Hashable, RawRepresentable {
}

protocol Coordinator: View {
    associatedtype Link: CoordinationLink
    var coordinationLink: Link? { get }
}
    
// MARK: - FirstView Coordinator
    
enum FirstViewCoordinationLink: Int, CoordinationLink {
    case secondView
}

struct FirstViewCoordinator: Coordinator {
    @State var coordinationLink: FirstViewCoordinationLink? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                FirstView(coordinationLink: $coordinationLink)
                NavigationLink(destination: SecondViewCoordinator(), tag: .secondView, selection: $coordinationLink) {
                    EmptyView()
                }
            }
        }
    }
}

// MARK: - SecondView Coordinator

enum SecondViewCoordinationLink: Int, CoordinationLink {
    case thirdView
}

struct SecondViewCoordinator: Coordinator {
    @State var coordinationLink: SecondViewCoordinationLink? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                SecondView(coordinationLink: $coordinationLink)
                NavigationLink(destination: ThirdViewCoordinator(), tag: .thirdView, selection: $coordinationLink) {
                    EmptyView()
                }
            }
        }
    }
}

// MARK: - ThirdView Coordinator

enum ThirdViewCoordinationLink: Int, CoordinationLink {
    case secondView
}

struct ThirdViewCoordinator: Coordinator {
    @State var coordinationLink: ThirdViewCoordinationLink? = nil
    
    var body: some View {
        NavigationView {
            ThirdView(coordinationLink: $coordinationLink)
        }
    }
}

// MARK: - Preview

PlaygroundPage.current.setLiveView(FirstViewCoordinator())
