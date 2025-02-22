import Foundation

final class Something: @unchecked Sendable {
    var mainExecutionContext: ExecutionContext = DispatchQueue.main
    var count = 0
    
    init() {}
    
    func makeUpdates() async {
        let data = await loadData()
        updateUI(data: data)
    }
    
    private func updateUI(data: String) {
        mainExecutionContext.execute { [unowned self] in
            guard Thread.isMainThread else { fatalError("Should be the main thread") }
            self.count += 1
        }
    }
    
    private func _updateUI(data: String) {
        DispatchQueue.main.async {
            self.count += 1
        }
    }
    
    private func loadData() async -> String {
        #function
    }
}

let foo = Something()
Task {
    await foo.makeUpdates()
}

RunLoop.main.run(until: .now + 2)
