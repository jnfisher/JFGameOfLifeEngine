//
//  GameBoard.swift
//  JFGameOfLifeEngine
//
//  Created by John Fisher on 2/7/15.
//  Copyright (c) 2015 John Fisher. All rights reserved.
//

import Foundation
import JFSparseMatrix

public func buildMatrix(array: Array<(Int, Int, String)>) -> SparseMatrix<Cell> {
    var matrix = SparseMatrix<Cell>()
    for a in array {
        if a.2 == "alive" {
            matrix[a.0, a.1] = Cell(state: CellState.Alive)
        }
        else if a.2 == "dead" {
            matrix[a.0, a.1] = Cell(state: CellState.Dead)
        }
        else {
            matrix[a.0, a.1] = Cell(state: CellState.Unaffected)
        }
    }
    return matrix
}

public class GameBoard<MatrixType: Matrix> {
    public let matrix: MatrixType
    let aliveRuleSet: Array<Rule>
    let deadRuleSet:  Array<Rule>
    
    public init(matrix : MatrixType, aliveRuleSet: Array<Rule>, deadRuleSet: Array<Rule>) {
        self.matrix = matrix
        self.aliveRuleSet = aliveRuleSet
        self.deadRuleSet = deadRuleSet
    }
    
    public func applyRules(index: SparseIndex) -> CellState {
        var state:CellState
        if let cell = matrix[index.row, index.col] {
            state = cell.state
        }
        else {
            state = CellState.Dead
        }
        
        var rules = state == CellState.Alive ? aliveRuleSet : deadRuleSet
        for rule in rules {
            var ruling = rule.apply(index, matrix: matrix)
            if ruling != CellState.Unaffected {
                return ruling
            }
        }

        return CellState.Dead
    }
}