//
//  GameOfLifeEngine.swift
//  JFGameOfLifeEngine
//
//  Created by John Fisher on 2/7/15.
//  Copyright (c) 2015 John Fisher. All rights reserved.
//

import Foundation
import JFSparseMatrix

public class Cell : Printable {
    public let state = CellState.Unaffected
    public init(state: CellState) {
        self.state = state
    }
    
    public var description: String {
        get {
            if self.state == CellState.Alive {
                return "alive"
            }
            else if self.state == CellState.Dead {
                return "dead"
            }
            else {
                return "unused"
            }
        }
    }
}

public typealias Matrix = SparseMatrix<Cell>
public typealias GameOfLifeBoard = GameBoard<Matrix>

extension SparseMatrix {
    
}

public class GameOfLifeEngine {
    public var currentBoard:GameBoard<Matrix>
    
    public init(initialBoard: GameBoard<Matrix>) {
        self.currentBoard = initialBoard
    }
    
    public init() {
        self.currentBoard = GameBoard(matrix: Matrix(), aliveRuleSet: ConwaysRules.aliveRuleset, deadRuleSet: ConwaysRules.deadRuleset)
    }
    
    public func step() -> GameBoard<Matrix> {
        var nextBoard = Matrix(array: processedCurrentlyAliveCells + processedLiveNeighboringCells)
        return GameBoard<Matrix>(matrix: nextBoard, aliveRuleSet: currentBoard.aliveRuleSet, deadRuleSet: currentBoard.deadRuleSet)
    }
    
    public func swap(newBoard: GameBoard<Matrix>) {
        self.currentBoard = newBoard
    }
    
    public var processedCurrentlyAliveCells: Array<(Int, Int, Cell)> {
        get {
            var cells = filter(map(currentBoard.matrix, { (key, cell) -> (Int, Int, Cell) in
                if cell.state == CellState.Alive {
                    return (key.row, key.col, Cell(state: self.currentBoard.applyRules(key)))
                }
                else {
                    return (key.row, key.col, Cell(state: CellState.Unaffected))
                }
            }), { $0.2.state != CellState.Unaffected })
            
            return cells
        }
    }
    
    public var processedLiveNeighboringCells: Array<(Int, Int, Cell)> {
        get {
            var processedCellCache = Matrix()
            
            for (index, cell) in currentBoard.matrix {
                if cell.state == CellState.Alive {
                    for (row, col) in index.moore {
                        if currentBoard.matrix[row, col]?.state == CellState.Alive {
                            // skip currently alive cells, they were already processed
                            continue
                        }
                        
                        if processedCellCache[row, col] == nil {
                            processedCellCache[row, col] = Cell(state: self.currentBoard.applyRules(SparseIndex(row: row, col: col)))
                        }
                    }
                }
            }
            
            return filter(map(processedCellCache, { (key, cell) -> (Int, Int, Cell) in
                return (key.row, key.col, cell)
            }), { $0.2.state == CellState.Alive })
        }
    }
}


