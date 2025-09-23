//
//  SolverTests.swift
//  AltonTests
//
//  Created by Aaron Nance on 5/22/23.
//

import XCTest
import APNUtil

@testable import Alton

final class CommandGetTests: ConsoleViewTestCase {
    
    // TODO: Clean Up - Move Data Struct to ConsoleViewTestCase
    struct Data {
        
        static let puzzleNumToData: [Int : [String]] = [
            
            665 : ["4458", "6", "07-15-24", "665"],
            666 : ["1344", "4", "07-16-24", "666"],
            667 : ["1335", "4", "07-17-24", "667"],
            668 : ["3566", "5", "07-18-24", "668"],
            669 : ["3799", "7", "07-19-24", "669"],
            670 : ["1458", "3", "07-20-24", "670"],
            671 : ["2299", "7", "07-21-24", "671"],
            672 : ["2458", "2", "07-22-24", "672"]
            
        ]
        
        static let dates = [
            "07-15-24",
            "07-16-24",
            "07-17-24",
            "07-18-24",
            "07-19-24",
            "07-20-24",
            "07-21-24",
            "07-22-24"
        ]
        
        static let digits = [
            "4458",
            "1344",
            "1335",
            "3566",
            "3799",
            "1458",
            "2299",
            "2458"
        ]
        
        static let puzzleNums = [
            "665",
            "666",
            "667",
            "668",
            "669",
            "670",
            "671",
            "672"
        ]
    }
    
    func setData() {
        
        assert(Data.dates.count >= Data.digits.count)
        
        // Nuke - Get Rid of User Inputted Digits
        utils.testCommand("nuke Y",
                          ["[Warning] Nuke successful: user saved puzzle(s) deleted."])
        
        // Check Expected Count
        utils.testCommand("get c \"0-3000\"",
                          ["0-3000: 152 puzzle(s)\n"])
        
        for i in 0..<Data.dates.count {
            let date = Data.dates[i]
            let digits = Data.digits[i]
            
            utils.testCommand("add \(digits) \"\(date)\"",
                              ["Archiving.*Succeeded\\.\\n"], useRegExMatching: true)
            
        }
        
    }
    
    // get <date>
    //
    // 'get 04-24-24' retrieves the archived puzzle with date  04-24-2024.
    func testGetByDate() {
        
        setData()
        
        for i in 0..<Data.dates.count {
            
            let date        = Data.dates[i]
            let num         = Data.puzzleNums[i]
            let digits      = Data.digits[i]
            let digitArray  = Int(digits)!.digits.sorted()
            
            let searchTerm  = date
            
            // No flag
            utils.testCommand("get \"\(searchTerm)\"",
                              ["\(searchTerm): \(RegExp.fullGetOutput)"],
                              shouldTrimOutput: true,
                              useRegExMatching: true)
            
            // 'c' flag "Count"
            utils.testCommand("get c \"\(searchTerm)\"",
                              ["\(searchTerm): 1 puzzle(s)"], shouldTrimOutput: true)
            
            // '-' flag "Digits"
            utils.testCommand("get \"-\" \"\(searchTerm)\"",
                              ["\(searchTerm): \(digitArray)"], shouldTrimOutput: true)
            
            // 'd' flag "Date"
            utils.testCommand("get d \"\(searchTerm)\"",
                              ["\(searchTerm)\\: \(RegExp.zeroPaddedSimpleDate)"],
                              shouldTrimOutput: true,
                              useRegExMatching: true)
            
            // 'n' flag "Puzzle #"
            utils.testCommand("get n \"\(searchTerm)\"",
                              ["\(searchTerm): \(num)"],
                              shouldTrimOutput: true,
                              useRegExMatching: true)
            
        }
        
    }
    
    // 'get 589' retrieves the archived puzzle data for the 589th
    // puzzle.
    func testGetByPuzzleNum() {
        
        setData()
        
        for i in 0..<Data.dates.count {
            
            let date        = Data.dates[i]
            let num         = Data.puzzleNums[i]
            let digits      = Data.digits[i]
            let digitArray  = Int(digits)!.digits.sorted()
            
            let searchTerm  = num
            
            // No flag
            utils.testCommand("get \"\(searchTerm)\"",
                              ["\(searchTerm): \(RegExp.fullGetOutput)"],
                              shouldTrimOutput: true,
                              useRegExMatching: true)
            
            // 'c' flag "Count"
            utils.testCommand("get c \"\(searchTerm)\"",
                              ["\(searchTerm): 1 puzzle(s)"], shouldTrimOutput: true)
            
            // '-' flag "Digits"
            utils.testCommand("get \"-\" \"\(searchTerm)\"",
                              ["\(searchTerm): \(digitArray)"], shouldTrimOutput: true)
            
            // 'd' flag "Date"
            utils.testCommand("get d \"\(searchTerm)\"",
                              ["\(searchTerm)\\: \(RegExp.zeroPaddedSimpleDate)"],
                              shouldTrimOutput: true,
                              useRegExMatching: true)
            
            // 'n' flag "Puzzle #"
            utils.testCommand("get n \"\(searchTerm)\"",
                              ["\(searchTerm): \(num)"],
                              shouldTrimOutput: true,
                              useRegExMatching: true)
            
        }
        
    }
    
    // get -<digits>
    //
    //  'get -1234' retrieves archived data for puzzle [1,2,3,4].
    //
    func testGetByDigits() {
        
        setData()
        
        for i in 0..<Data.dates.count {
            
            let date        = Data.dates[i]
            let num         = Data.puzzleNums[i]
            let digits      = Data.digits[i]
            let digitArray  = Int(digits)!.digits.sorted()
            
            let searchTerm  = "-\(digits)"
            
            // No flag
            utils.testCommand("get \"\(searchTerm)\"",
                              ["\(searchTerm): \(RegExp.fullGetOutput)"],
                              shouldTrimOutput: true,
                              useRegExMatching: true)
            
            // 'c' flag "Count"
            utils.testCommand("get c \"\(searchTerm)\"",
                              ["\(searchTerm): 1 puzzle(s)"], shouldTrimOutput: true)
            
            // '-' flag "Digits"
            utils.testCommand("get \"-\" \"\(searchTerm)\"",
                              ["\(searchTerm): \(digitArray)"], shouldTrimOutput: true)
            
            // 'd' flag "Date"
            utils.testCommand("get d \"\(searchTerm)\"",
                              ["\(searchTerm)\\: \(RegExp.zeroPaddedSimpleDate)"],
                              shouldTrimOutput: true,
                              useRegExMatching: true)
            
            // 'n' flag "Puzzle #"
            utils.testCommand("get n \"\(searchTerm)\"",
                              ["\(searchTerm): \(num)"],
                              shouldTrimOutput: true,
                              useRegExMatching: true)
            
        }
        
    }
    
    
    // get 359-400
    func testGetByRange() {
        
        setData()
        
        let ranges = ["665-666",
                      "666-667",
                      "665-667"]
        
        let puzzleNums =
        [
            [665,666],
            [666,667],
            [665,666,667]
        ]
        
        for i in 0..<ranges.count {
            
            let num             = Data.puzzleNums[i]
            
            let firstNum        = puzzleNums[i].first!
            let lastNum         = puzzleNums[i].last!
            let expectedCount   = (lastNum - firstNum) + 1
            
            let searchTerm      = "\(firstNum)-\(lastNum)"
            
            var expectedMultiNoFlag = ""
            var expectedDigitArrays = ""
            var expectedDates       = ""
            var expectedNums        = ""
            
            for num in puzzleNums[i] {
                
                let puzzleData = Data.puzzleNumToData[num]!
                
                let raw = puzzleData.joined(separator: ";")
                expectedMultiNoFlag += " \(raw) \n"
                
                // Build Digits Output
                let digits          = puzzleData[0]
                expectedDigitArrays += Int(digits)!.digits.sorted().description + " "
                
                // Build Dates
                expectedDates += puzzleData[2] + " "
                
                // Build Nums
                expectedNums += puzzleData[3] + " "
                
            }
            
            // No flag
            utils.testCommand("get \"\(searchTerm)\"",
                              ["\(searchTerm):\(expectedMultiNoFlag)"],
                              shouldTrimOutput: true)
            
            // 'c' flag "Count"
            utils.testCommand("get c \"\(searchTerm)\"",
                              ["\(searchTerm): \(expectedCount) puzzle(s)"], shouldTrimOutput: true)
            
            // '-' flag "Digits"
            utils.testCommand("get \"-\" \"\(searchTerm)\"",
                              ["\(searchTerm): \(expectedDigitArrays.trim())"], shouldTrimOutput: true)
            
            // 'd' flag "Date"
            utils.testCommand("get d \"\(searchTerm)\"",
                              ["\(searchTerm): \(expectedDates.trim())"], shouldTrimOutput: true)
            
            // 'n' flag "Puzzle #"
            utils.testCommand("get n \"\(searchTerm)\"",
                              ["\(searchTerm): \(expectedNums.trim())"], shouldTrimOutput: true)
            
        }
        
    }
    
}
