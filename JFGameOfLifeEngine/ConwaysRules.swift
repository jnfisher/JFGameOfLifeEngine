//
//  ConwaysRules.swift
//  JFGameOfLifeEngine
//
//  Created by John Fisher on 2/7/15.
//  Copyright (c) 2015 John Fisher. All rights reserved.
//

import Foundation
import JFSparseMatrix

public struct ConwaysRules {
    public static let aliveRuleset = [FewerThanTwoLiveNeighbors(), TwoOrThreeLiveNeighbors(), MoreThanThreeLiveNeighbors()]
    public static let deadRuleset  = [ExactlyThreeLiveNeighbors()]
}

public class FewerThanTwoLiveNeighbors : Rule {
    public override func apply(index: SparseIndex, matrix: Matrix) -> CellState {
        return aliveNeighbors(index, matrix: matrix) < 2 ? CellState.Dead : CellState.Unaffected
    }
}

public class TwoOrThreeLiveNeighbors : Rule {
    public override func apply(index: SparseIndex, matrix: Matrix) -> CellState {
        let alive = aliveNeighbors(index, matrix: matrix)
        return alive == 2 || alive == 3 ? CellState.Alive : CellState.Unaffected
    }
}

public class MoreThanThreeLiveNeighbors : Rule {
    public override func apply(index: SparseIndex, matrix: Matrix) -> CellState {
        return aliveNeighbors(index, matrix: matrix) > 3 ? CellState.Dead : CellState.Unaffected
    }
}

public class ExactlyThreeLiveNeighbors : Rule {
    public override func apply(index: SparseIndex, matrix: Matrix) -> CellState {
        return aliveNeighbors(index, matrix: matrix) == 3 ? CellState.Alive : CellState.Unaffected
    }
}
