import Foundation

// Source code for article
// https://zalogatomek.medium.com/interface-segregation-principle-look-from-a-different-side-e61bcedc8d58

// MARK: - Basic Data definition

struct MyData {
    var name: String = "name"
    var value: Double = 1.0
}

protocol MyDataRepository {
    var myData: MyData { get }
    func set(myData: MyData)
}

final class MyDataRepositoryImpl: MyDataRepository {
    
    // MARK: - Properties
    
    private static var sharedMyData: MyData = MyData()
    
    // MARK: - MyDataRepository
    
    var myData: MyData { Self.sharedMyData }
    
    func set(myData: MyData) {
        Self.sharedMyData = myData
    }
}

// MARK: - Problem: Class printing stored MyData on demand

// Normal approach: just inject repository

final class MyDataPrinter_Normal {
    
    // MARK: - Properties
    
    private let repository: MyDataRepository
    
    // MARK: - Lifecycle
    
    init(repository: MyDataRepository) {
        self.repository = repository
    }
    
    // MARK: - Print MyData
    
    func printMyData() -> String {
        let myData = repository.myData
        return "MyData name: \(myData.name), value: \(myData.value)"
    }
}

let myClassNormal = MyDataPrinter_Normal(repository: MyDataRepositoryImpl())
let firstExample = myClassNormal.printMyData()
print("Example 1: \(firstExample)")

// Inject only whats needed

final class MyDataPrinter_InjectClosure {
    
    // MARK: - Properties
    
    private let myDataProvider: () -> MyData
    
    // MARK: - Lifecycle
    
    init(myDataProvider: @escaping () -> MyData) {
        self.myDataProvider = myDataProvider
    }
    
    // MARK: - Print MyData
    
    func printMyData() -> String {
        let myData = myDataProvider()
        return "MyData name: \(myData.name), value: \(myData.value)"
    }
}

let myDataProvider: () -> MyData = { MyDataRepositoryImpl().myData }
let myClassInjectClosure = MyDataPrinter_InjectClosure(myDataProvider: myDataProvider)
let secondExample = myClassInjectClosure.printMyData()
print("Example 2: \(secondExample)")

