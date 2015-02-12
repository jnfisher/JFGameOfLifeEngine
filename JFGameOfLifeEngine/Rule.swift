//
//  Rule.swift
//  JFGameOfLifeEngine
//
//  Created by John Fisher on 2/7/15.
//  Copyright (c) 2015 John Fisher. All rights reserved.
//

import Foundation
import JFSparseMatrix

public enum CellState {
    case Unaffected
    case Dead
    case Alive
}

public protocol ApplicableRule {
    func apply(index: SparseIndex, matrix: Matrix) -> CellState
}

public class Rule : ApplicableRule {
    public func apply(index: SparseIndex, matrix: Matrix) -> CellState {
        return CellState.Unaffected
    }
    
    func aliveNeighbors(index: SparseIndex, matrix: Matrix) -> Int {
        return index.moore.reduce(0, {
            if let data = matrix[$1.0, $1.1] {
                let cell = data as Cell
                if cell.state == CellState.Alive {
                    return $0 + 1
                }
            }
            return $0
        })
    }
}