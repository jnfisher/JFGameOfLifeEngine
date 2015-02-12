//
//  GameBoard.swift
//  JFGameOfLifeEngine
//
//  Created by John Fisher on 2/7/15.
//  Copyright (c) 2015 John Fisher. All rights reserved.
//

import Foundation
import JFSparseMatrix

public class GameBoard<MatrixType: Matrix> {
    public let board: MatrixType
    let aliveRuleSet: Array<Rule>
    let deadRuleSet:  Array<Rule>
    
    public init(board : MatrixType, aliveRuleSet: Array<Rule>, deadRuleSet: Array<Rule>) {
        self.board = board
        self.aliveRuleSet = aliveRuleSet
        self.deadRuleSet = deadRuleSet
    }
    
    public func applyRules(index: SparseIndex) -> CellState {
        var state:CellState
        if let cell = board[index.row, index.col] {
            state = cell.state
        }
        else {
            state = CellState.Dead
        }
        
        var rules = state == CellState.Alive ? aliveRuleSet : deadRuleSet
        for rule in rules {
            var ruling = rule.apply(index, matrix: board)
            if ruling != CellState.Unaffected {
                return ruling
            }
        }

        return CellState.Dead
    }
}