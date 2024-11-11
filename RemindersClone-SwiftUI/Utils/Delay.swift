//
//  Delay.swift
//  RemindersClone-SwiftUI
//
//  Created by Dongjun Lee on 11/11/24.
//

import Foundation

class Delay {
    
    private var seconds: Double
    var workItem: DispatchWorkItem?
    
    init(seconds: Double = 2.0, workItem: DispatchWorkItem? = nil) {
        self.seconds = seconds
        self.workItem = workItem
    }
    
    func performWork(_ work: @escaping () -> Void) {
        workItem = DispatchWorkItem(block: {
            work()
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: workItem!)
    }
    
    func cancel() {
        workItem?.cancel()
    }
    
}
