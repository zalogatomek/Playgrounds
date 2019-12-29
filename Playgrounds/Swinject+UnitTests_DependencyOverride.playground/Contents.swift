import Foundation
import XCTest
import Swinject

// MARK: - Domain

struct MyModel: Codable, CustomStringConvertible {
    var stringProperty: String
    var description: String { return stringProperty }
}

protocol MyModelService {
    func models(completion: @escaping ([MyModel]) -> Void)
}

protocol MyDependency {
    var string: String { get }
}

// MARK: - Infrastructure

struct BaseMyModelService: MyModelService {
    private var dependency: MyDependency
    private var models: [MyModel]
    
    init(dependency: MyDependency) {
        self.dependency = dependency
        self.models = (0..<10).map {
            MyModel(stringProperty: "\(dependency.string)_\($0)")
        }
    }
    
    func models(completion: @escaping ([MyModel]) -> Void) {
        completion(models)
    }
}

// MARK: - App implementation

struct AppMyDependency: MyDependency {
    var string: String = "application"
}

// MARK: - Test implementation

struct TestMyDependency: MyDependency {
    var string: String = "test"
}

// MARK: - Dependency injection

struct ApplicationContainer {
    private init() { }
    
    static let shared: Container = Container()
    
    static func assemble() {
        shared.register(MyDependency.self) { resolver in
            return AppMyDependency()
        }
        
        shared.register(MyModelService.self) { resolver in
            let dependency = resolver.resolve(MyDependency.self)!
            return BaseMyModelService(dependency: dependency)
        }
    }
}

// MARK: - App code

ApplicationContainer.assemble()

let service = ApplicationContainer.shared.resolve(MyModelService.self)!
service.models(completion: { models in
    print(models)
})

// MARK: - Overidde registered dependency for unit tests

class BaseMyModelServiceTests: XCTestCase {
    var service: BaseMyModelService!
    
    override func setUp() {
        super.setUp()
        setupDependency()
        service = (ApplicationContainer.shared.resolve(MyModelService.self) as! BaseMyModelService)
    }
    
    private func setupDependency() {
        ApplicationContainer.shared.register(MyDependency.self) { resolver in
            return TestMyDependency()
        }
    }
    
    func testModels() {
        let expectation = XCTestExpectation()
        service.models(completion: { models in
            XCTAssertEqual(models.count, 10)
            XCTAssertTrue(models.allSatisfy{ $0.stringProperty.contains("test") })
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)
    }
}

BaseMyModelServiceTests.defaultTestSuite.run()
