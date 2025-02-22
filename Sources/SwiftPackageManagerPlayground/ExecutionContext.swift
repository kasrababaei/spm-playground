import Foundation
import Combine

protocol ExecutionContext: Sendable {
    @discardableResult
    func execute(_ execute: @escaping () -> Void) -> Cancellable
    
    @discardableResult
    func execute(after: TimeInterval, execute: @escaping () -> Void) -> Cancellable
}

extension DispatchQueue: ExecutionContext {
    @discardableResult
    public func execute(_ execute: @escaping () -> Void) -> Cancellable {
        let workItem = DispatchWorkItem(block: execute)
        async(execute: workItem)
        return workItem
    }
    
    @discardableResult
    public func execute(after: TimeInterval, execute: @escaping () -> Void) -> Cancellable {
        let workItem = DispatchWorkItem(block: execute)
        asyncAfter(deadline: .now() + after, execute: workItem)
        return workItem
    }
}

extension DispatchWorkItem: @retroactive Cancellable {}

final class LoginView {
    // @Injected(\.mainExecutionContext)
    var mainExecutionContext: ExecutionContext = DispatchQueue.main
    
    func runOnMainThread() {
        mainExecutionContext.execute {
            // Some work...
        }
    }
}

// For testing
struct ImmediateExecutionContext: ExecutionContext {
    func execute(_ execute: @escaping () -> Void) -> Cancellable {
        execute()
        return NoopCancellable()
    }
    
    func execute(after: TimeInterval, execute: @escaping () -> Void) -> Cancellable {
        execute()
        return NoopCancellable()
    }
}

final class MockExecutionContext: ExecutionContext, @unchecked Sendable {
    var mockExecute: (() -> Void)?
    func execute(_ execute: @escaping () -> Void) -> Cancellable {
        mockExecute = execute
        return NoopCancellable()
    }
    
    var mockExecuteAfter: (() -> Void)?
    func execute(after: TimeInterval, execute: @escaping () -> Void) -> Cancellable {
        mockExecuteAfter = execute
        return NoopCancellable()
    }
}

final class NoopCancellable: Cancellable {
    func cancel() {
        let _ = print(#function, #line, "Cancelled was called.")
    }
}
