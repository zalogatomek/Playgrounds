import PlaygroundSupport
import SwiftUI

// MARK: - Views (Screens)

struct FirstView: View {
    @Binding var coordinatorTag: FirstViewCoordinatorTag?
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.red)
            
            Button("Go to Second View") {
                self.coordinatorTag = .secondView
            }
        }
        .navigationBarTitle("First View")
    }
}

struct SecondView: View {
    @Binding var coordinatorTag: SecondViewCoordinatorTag?
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.green)
            
            Button("Go to Third View") {
                self.coordinatorTag = .thirdView
            }
        }
        .navigationBarTitle("Second View")
    }
}

struct ThirdView: View {
    @Binding var coordinatorTag: ThirdViewCoordinatorTag?
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.blue)
        }
        .navigationBarTitle("ThirdView View")
    }
}

// MARK: - Coordinators

protocol CoordinatorTag: Hashable, RawRepresentable {
}

protocol Coordinator: View {
    associatedtype Tag: CoordinatorTag
    var coordinatorTag: Tag? { get }
}

struct CoordinatorLink<Destination, Tag>: View where Destination: View, Tag: CoordinatorTag {
    private var destination: Destination
    private var tag: Tag
    private var selection: Binding<Tag?>
    
    init(destination: Destination, tag: Tag, selection: Binding<Tag?>) {
        self.destination = destination
        self.tag = tag
        self.selection = selection
    }
    
    var body: some View {
        NavigationLink(destination: destination, tag: tag, selection: selection) {
            EmptyView()
        }
    }
}

// MARK: - Application Coordinator

enum ApplicationCoordinatorTag: Int, CoordinatorTag {
    case firstView
}

struct ApplicationCoordinator: Coordinator {
    @State var coordinatorTag: ApplicationCoordinatorTag? = .firstView
    
    var body: some View {
        NavigationView {
            currentView
        }
    }
    
    var currentView: AnyView {
        switch coordinatorTag {
        case .firstView:
            return AnyView(FirstViewCoordinator())
        case .none:
            return AnyView(EmptyView())
        }
    }
}
    
// MARK: - FirstView Coordinator
    
enum FirstViewCoordinatorTag: Int, CoordinatorTag {
    case secondView
}

struct FirstViewCoordinator: Coordinator {
    @State var coordinatorTag: FirstViewCoordinatorTag? = nil
    
    var body: some View {
        ZStack {
            FirstView(coordinatorTag: $coordinatorTag)
            CoordinatorLink(destination: SecondViewCoordinator(), tag: .secondView, selection: $coordinatorTag)
        }
    }
}

// MARK: - SecondView Coordinator

enum SecondViewCoordinatorTag: Int, CoordinatorTag {
    case thirdView
}

struct SecondViewCoordinator: Coordinator {
    @State var coordinatorTag: SecondViewCoordinatorTag? = nil
    
    var body: some View {
        ZStack {
            SecondView(coordinatorTag: $coordinatorTag)
            CoordinatorLink(destination: ThirdViewCoordinator(), tag: .thirdView, selection: $coordinatorTag)
        }
    }
}

// MARK: - ThirdView Coordinator

enum ThirdViewCoordinatorTag: Int, CoordinatorTag {
    case secondView
}

struct ThirdViewCoordinator: Coordinator {
    @State var coordinatorTag: ThirdViewCoordinatorTag? = nil
    
    var body: some View {
        ThirdView(coordinatorTag: $coordinatorTag)
    }
}

// MARK: - Preview

PlaygroundPage.current.setLiveView(ApplicationCoordinator())
