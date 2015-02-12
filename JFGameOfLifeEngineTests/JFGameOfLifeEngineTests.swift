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
    var subject = GameOfLifeEngine()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSteadyStateBlock() {
        var state = [(0, 0, "alive"), (0, 1, "alive"), (1, 1, "alive"), (1, 0, "alive")]
        subject.swap(GameBoard(matrix: buildMatrix(state), aliveRuleSet: ConwaysRules.aliveRuleset, deadRuleSet: ConwaysRules.deadRuleset))
        
        var next = subject.step()
    
        XCTAssert(next.matrix[0, 0]?.state == CellState.Alive)
        XCTAssert(next.matrix[0, 1]?.state == CellState.Alive)
        

        XCTAssert(next.matrix[1, 1]?.state == CellState.Alive)
        XCTAssert(next.matrix[1, 0]?.state == CellState.Alive)
        
        subject.swap(next)
        next = subject.step()
        XCTAssert(next.matrix[0, 0]?.state == CellState.Alive)
        XCTAssert(next.matrix[0, 1]?.state == CellState.Alive)
        
        XCTAssert(next.matrix[1, 1]?.state == CellState.Alive)
        XCTAssert(next.matrix[1, 0]?.state == CellState.Alive)
    }
    
    
    func testDoomedPair() {
        var state = [(0, 0, "alive"), (1, 0, "alive")]
        subject.swap(GameBoard(matrix: buildMatrix(state), aliveRuleSet: ConwaysRules.aliveRuleset, deadRuleSet: ConwaysRules.deadRuleset))
        
        var next = subject.step()
        XCTAssert(next.matrix[0,0]?.state == CellState.Dead)
        XCTAssert(next.matrix[1,0]?.state == CellState.Dead)
    }
    
    func testDeadCellsPersist() {
        var state = [(0, 0, "alive")]
        subject.swap(GameBoard(matrix: buildMatrix(state), aliveRuleSet: ConwaysRules.aliveRuleset, deadRuleSet: ConwaysRules.deadRuleset))
        
        var next = subject.step()
        XCTAssert(next.matrix[0,0]?.state == CellState.Dead)
        XCTAssert(next.matrix.count == 1)
    }
    
    func testBlinker() {
        // *
        // *
        // *
        var state = [(-1, 0, "alive"), (0, 0, "alive"), (1, 0, "alive")]
        subject.swap(GameBoard(matrix: buildMatrix(state), aliveRuleSet: ConwaysRules.aliveRuleset, deadRuleSet: ConwaysRules.deadRuleset))
        
        var next = subject.step()
        subject.swap(next)
        // * * *
        XCTAssert(next.matrix[0, 0]?.state == CellState.Alive)
        XCTAssert(next.matrix[0,-1]?.state == CellState.Alive)
        XCTAssert(next.matrix[0, 1]?.state == CellState.Alive)
        
        next = subject.step()
        subject.swap(next)
        // *
        // *
        // *
        XCTAssert(next.matrix[0, 0]?.state == CellState.Alive)
        XCTAssert(next.matrix[-1,0]?.state == CellState.Alive)
        XCTAssert(next.matrix[1, 0]?.state == CellState.Alive)
        
        next = subject.step()
        subject.swap(next)
        // * * *
        XCTAssert(next.matrix[0, 0]?.state == CellState.Alive)
        XCTAssert(next.matrix[0,-1]?.state == CellState.Alive)
        XCTAssert(next.matrix[0, 1]?.state == CellState.Alive)
    }
}
