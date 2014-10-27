//
//  main.swift
//  GameOfLife
//
//  Created by Silfang, Christian on 20.10.14.
//  Copyright (c) 2014 Silfang, Christian. All rights reserved.
//

// Matrizen in Swift
// https://developer.apple.com/library/ios/documentation/swift/conceptual/swift_programming_language/Subscripts.html
// Game Of Life - Swift und SpriteKit
// https://www.makegameswith.us/gamernews/399/create-the-game-of-life-using-swift-and-spritekit

import Foundation
import Darwin

// DEBUG ARRAY - append (1. Vesuch) -> Matrix einfacher!!!
//
//var NumColumns = 20
//var NumRows = 20
//var board = Array<Array<Int>>()

//for column in 0...NumColumns {
//    board.append(Array(count: NumRows, repeatedValue: Int()))
//}

//for var i=0;i<NumColumns;i++ {
//    print(" \(0) ")
//    for var j=0;j<NumRows;j++ {
//        print(" \(0) ")
//    }
//    println("")
//}

var rows = 20;              // Reihen - Matrix
var columns = 20;           // Spalten - Matrix
var start_population = 100;  // Startpopulation
var cycles = 20;            // Spielzyklen
var pause:UInt32 = 1;              // Pause zwischen Zyklus

// Spielfeld definieren - Swift Matrix
struct Matrix {
    let rows: Int, columns: Int
    
    var grid: [Int]
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(count: rows * columns, repeatedValue: 0)
    }
    
    func indexIsValidForRow(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    
    subscript(row: Int, column: Int) -> Int {
        
        get {
            assert(indexIsValidForRow(row, column: column), "IOR")
            return grid[(row * columns) + column]
        }
    
        set {
            assert(indexIsValidForRow(row, column: column), "IOR")
            grid[(row * columns) + column] = newValue
        }
    }
}

// Spielfeldgröße
var matrix = Matrix(rows: rows, columns: columns)
var new_matrix = Matrix(rows: rows, columns: columns)
var empty_matrix = Matrix(rows: rows, columns: columns)

// Anfangspopulation
for var i = 0; i <= start_population; i++ {
    matrix[Int(arc4random_uniform(UInt32(rows-1))), Int(arc4random_uniform(UInt32(columns-1)))] = 1;
}

// Durchläufe für Spielzyklen
var neighbors = 0

for var count = 1; count <= cycles; count++ {
    
    // INFO
    println(" ")
    println("Zyklus: \(count) / \(cycles)")
    
    for var i = 0; i < matrix.columns; i++ {
        print("|") // linke Begrenzung
        
        for var j = 0; j < matrix.rows; j++ {
            
            if(matrix.indexIsValidForRow(j, column: i)) {
                print(matrix[i, j])
                print("")
            }
        }
        println("|") // rechte Begrenzung
    }
    
    // Leere Matrix
    new_matrix = empty_matrix
    
    // Jede Position
    for var col = 1; col < matrix.columns-1; col++
    {
        for var row = 1; row < matrix.rows-1; row++
        {
            neighbors = 0
            
            // Nachbarn zählen
            if(row > 0) {
                if(matrix[row-1,col] == 1) { neighbors++ }
            }
            
            if(col > 0) {
                if(matrix[row,col-1] == 1) { neighbors++ }
            }
            
            if(col > 0 && row > 0) {
                if(matrix[row-1,col-1] == 1) { neighbors++ }
            }
            
            if(col > 0 && row < matrix.rows-1) {
                if(matrix[row+1,col-1] == 1) { neighbors++ }
            }
            
            if(row < matrix.rows-1) {
                if(matrix[row+1,col] == 1) { neighbors++ }
            }
            
            if(row < matrix.rows-1 && col < matrix.columns-1) {
                if(matrix[row+1,col+1] == 1) { neighbors++ }
            }
            
            if(col < matrix.columns-1) {
                if(matrix[row,col+1] == 1) { neighbors++ }
            }
            
            if(row > 0 && col < matrix.columns-1) {
                if(matrix[row-1,col+1] == 1) { neighbors++ }
            }
            
            if(matrix[row,col] == 0 && neighbors == 3) { new_matrix[row,col] = 1 }
            
            if(matrix[row,col] == 1 && neighbors > 3) { new_matrix[row,col] = 2 }
            
            if(matrix[row,col] == 1 && neighbors < 3) { new_matrix[row,col] = 2 }
            
            if(matrix[row,col] == 1 && (neighbors == 3 || neighbors == 2)) { new_matrix[row,col] = 1 }
            
        }
        
    }
    
    for var col = 0; col < matrix.columns; col++
    {
        for var row = 0; row < matrix.rows; row++
        {
            if(new_matrix[row,col] == 1) { matrix[row,col] = 1 }
            if(new_matrix[row,col] == 2) { matrix[row,col] = 0 }
        }
    }
    sleep(pause)
}