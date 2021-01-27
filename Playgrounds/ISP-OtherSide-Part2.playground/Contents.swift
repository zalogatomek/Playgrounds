import Foundation
import RxSwift

// MARK: - Basic Data definition

struct MyData {
    var name: String = "name"
    var value: Double = 1.0
}

protocol MyDataRepository {
    var myDataObservable: Observable<MyData> { get }
    func set(myData: MyData)
}

final class MyDataRepositoryImpl: MyDataRepository {
    
    // MARK: - Properties
    
    private var myDataSubject: PublishSubject<MyData> = PublishSubject()
    
    // MARK: - MyDataRepository
    
    func set(myData: MyData) {
        myDataSubject.onNext(myData)
    }
    
    var myDataObservable: Observable<MyData> {
        return myDataSubject.asObservable()
    }
}

// MARK: - Problem2: MyClass should print stored MyData every time it changes

// Normal approach: just inject repository

final class MyClassObserving_Normal {
    
    // MARK: - Properties
    
    private let repository: MyDataRepository
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    init(repository: MyDataRepository) {
        self.repository = repository
        bindRepository()
    }
    
    private func bindRepository() {
        repository.myDataObservable
            .subscribe(onNext: { [weak self] myData in
                self?.printMyData(myData)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Print MyData
    
    private func printMyData(_ myData: MyData) {
        print(myData)
    }
}

print("---- Example 3 ----")
let myClassObservingNormalRepostory = MyDataRepositoryImpl()
let myClassObservingNormal = MyClassObserving_Normal(repository: myClassObservingNormalRepostory)
myClassObservingNormalRepostory.set(myData: MyData(name: "differentName", value: 2.0))

// Inject only observable

final class MyClassObserving_OnlyObservable {
    
    // MARK: - Properties
    
    private let myDataObservable: Observable<MyData>
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    init(myDataObservable: Observable<MyData>) {
        self.myDataObservable = myDataObservable
        bindRepository()
    }
    
    private func bindRepository() {
        myDataObservable
            .subscribe(onNext: { [weak self] myData in
                self?.printMyData(myData)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Print MyData
    
    private func printMyData(_ myData: MyData) {
        print(myData)
    }
}

print("---- Example 4 ----")
let myClassObservingOnlyObservableRepostory = MyDataRepositoryImpl()
var myClassObservingOnlyObservable: MyClassObserving_OnlyObservable? = MyClassObserving_OnlyObservable(myDataObservable: myClassObservingOnlyObservableRepostory.myDataObservable)
myClassObservingOnlyObservableRepostory.set(myData: MyData(name: "newName", value: 3.0))
myClassObservingOnlyObservable = nil

// Inject only observable - demostrating memory problem

print("---- Example 5 ----")
let myClassObservingOnlySecondObservable = MyClassObserving_OnlyObservable(myDataObservable: MyDataRepositoryImpl().myDataObservable)
myClassObservingOnlyObservableRepostory.set(myData: MyData(name: "nextName", value: 4.0))
