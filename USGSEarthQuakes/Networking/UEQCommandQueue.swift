//
//  UEQCommandQueue.swift
//  USGSEarthQuakes
//
//  Created by Sreekanth Ruthala on 1/26/20.
//  Copyright © 2020 Sreekanth Ruthala. All rights reserved.
//

import Foundation

enum UEQCommandException: Error {
    case Invalid
}

protocol UEQCommand {
    func execute() throws
}

//** GFInteractor adds needed commands to the command queue.
class UEQCommandQueue {
    
    let gfQueue: OperationQueue

    init() {
        gfQueue = OperationQueue.init()
        gfQueue.maxConcurrentOperationCount = 1
    }
    
    func run(command: UEQCommand) {
        gfQueue.addOperation {
            try? command.execute()
        }
    }
    
    func combineCommands(in sequence:[UEQCommand]) {
        sequence.forEach { (command) in
            gfQueue.addOperation {
                try? command.execute()
            }
        }
    }
    
    
}
