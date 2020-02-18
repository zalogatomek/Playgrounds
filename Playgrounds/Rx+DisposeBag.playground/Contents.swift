import RxSwift

// Check, if its safe to use disposeBag inside struct

class AClass {
    let uuid: UUID = UUID()
    let event: PublishSubject<Void> = PublishSubject()
    let disposeBag: DisposeBag = DisposeBag()
    
    init() {
        let uuid = self.uuid
        event.subscribe(onNext: {
            print("class onNext")
        }, onDisposed: {
            print("class disposed")
        }).disposed(by: disposeBag)
    }
}

struct AStruct {
    let event: PublishSubject<Void> = PublishSubject()
    let disposeBag: DisposeBag = DisposeBag()
    
    init() {
        event.subscribe(onNext: {
            print("struct onNext")
        }, onDisposed: {
            print("struct disposed")
        }).disposed(by: disposeBag)
    }
}

var aClass: AClass? = AClass()
aClass?.event.onNext(())                // event properly called

var aStruct: AStruct? = AStruct()
aStruct?.event.onNext(())               // event properly called

aClass = nil                            // subscription properly disposed
aStruct = nil                           // subscription properly disposed
