//
//  JFGameOfLifeEngineTests.swift
//  JFGameOfLifeEngineTests
//
//  Created by John Fisher on 2/7/15.
//  Copyright (c) 2015 John Fisher. All rights reserved.
//

import UIKit
import XCTest
import JFSparseMatrix
import JFGameOfLifeEngine

class JFGameOfLifeEngineTests: XCTestCase {
    func buildMatrix(array: Array<(Int, Int, String)>) -> SparseMatrix<Cell> {
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
    
    var subject = GameOfLifeEngine()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSteadyStateBlock() {
        var state = [(0, 0, "alive"), (0, 1, "alive"), (1, 1, "alive"), (1, 0, "alive")]
        subject.swap(GameBoard(board: buildMatrix(state), aliveRuleSet: ConwaysRules.aliveRuleset, deadRuleSet: ConwaysRules.deadRuleset))
        
        var next = subject.step()
    
        XCTAssert(next.board[0, 0]?.state == CellState.Alive)
        XCTAssert(next.board[0, 1]?.state == CellState.Alive)
        

        XCTAssert(next.board[1, 1]?.state == CellState.Alive)
        XCTAssert(next.board[1, 0]?.state == CellState.Alive)
        
        subject.swap(next)
        next = subject.step()
        XCTAssert(next.board[0, 0]?.state == CellState.Alive)
        XCTAssert(next.board[0, 1]?.state == CellState.Alive)
        
        XCTAssert(next.board[1, 1]?.state == CellState.Alive)
        XCTAssert(next.board[1, 0]?.state == CellState.Alive)
    }
    
    
    func testDoomedPair() {
        var state = [(0, 0, "alive"), (1, 0, "alive")]
        subject.swap(GameBoard(board: buildMatrix(state), aliveRuleSet: ConwaysRules.aliveRuleset, deadRuleSet: ConwaysRules.deadRuleset))
        
        var next = subject.step()
        XCTAssert(next.board[0,0]?.state == CellState.Dead)
        XCTAssert(next.board[1,0]?.state == CellState.Dead)
    }
    
    func testDeadCellsPersist() {
        var state = [(0, 0, "alive")]
        subject.swap(GameBoard(board: buildMatrix(state), aliveRuleSet: ConwaysRules.aliveRuleset, deadRuleSet: ConwaysRules.deadRuleset))
        
        var next = subject.step()
        XCTAssert(next.board[0,0]?.state == CellState.Dead)
        XCTAssert(next.board.count == 1)
    }
    
    func testBlinker() {
        // *
        // *
        // *
        var state = [(-1, 0, "alive"), (0, 0, "alive"), (1, 0, "alive")]
        subject.swap(GameBoard(board: buildMatrix(state), aliveRuleSet: ConwaysRules.aliveRuleset, deadRuleSet: ConwaysRules.deadRuleset))
        
        var next = subject.step()
        subject.swap(next)
        // * * *
        XCTAssert(next.board[0, 0]?.state == CellState.Alive)
        XCTAssert(next.board[0,-1]?.state == CellState.Alive)
        XCTAssert(next.board[0, 1]?.state == CellState.Alive)
        
        next = subject.step()
        subject.swap(next)
        // *
        // *
        // *
        XCTAssert(next.board[0, 0]?.state == CellState.Alive)
        XCTAssert(next.board[-1,0]?.state == CellState.Alive)
        XCTAssert(next.board[1, 0]?.state == CellState.Alive)
        
        next = subject.step()
        subject.swap(next)
        // * * *
        XCTAssert(next.board[0, 0]?.state == CellState.Alive)
        XCTAssert(next.board[0,-1]?.state == CellState.Alive)
        XCTAssert(next.board[0, 1]?.state == CellState.Alive)
    }
}
