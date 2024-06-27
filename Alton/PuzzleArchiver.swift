//
//  PuzzleArchiver.swift
//  Alton
//
//  Created by Aaron Nance on 6/21/24.
//

import APNUtil
import Foundation

class PuzzleArchiver {
    
    /// Singleton
    static var shared = PuzzleArchiver()
    
    private var archive: ManagedCollection<ArchivedPuzzle> = ManagedCollection.load(file: Configs.Archiver.File.saved.name,
                                                                            inSubDir: Configs.Archiver.File.saved.subDir)
    
    func byDate() -> [ArchivedPuzzle] {
        
        archive.values.sorted{ $0.date < $1.date }
        
    }
    
    /// Use `shared` singleton
    private init() {
        
        loadFromDefaults()
        
    }
    
    /// Calculates the All Ten puzzle number based on today's date.
    static var todaysPuzzleNumber: Int {
        
        calcPuzzleNum(forDate: Date().simple.simpleDate)
        
    }
    
    static var tomorrowsPuzzleNumber: Int {
        
        todaysPuzzleNumber + 1
        
    }
    
    /// Calculates the All Ten puzzle number based the specified `forDate`.
    static func calcPuzzleNum(forDate date: Date) -> Int {
        
        date.daysFrom(earlierDate: Configs.Puzzle.originalPuzzleDate) + 1
        
    }
    
    /// Loads archived `ArchivedPuzzle` into archive
    private func loadFromDefaults() {
        
        if archive.count > 0 { return /*EXIT*/ }
        
        // Defaults - Hard-Coded List of Previous Puzzles
        let file = Configs.Archiver.File.defaults
            
            print("Loading Archived Puzzle Data From File: \(file.name).\(file.type)")
            
            var lines = [String]()
            
            if let path = Bundle.main.path(forResource: file.name, ofType: file.type) {
                
                do {
                    
                    let text = try String(contentsOfFile: path).snip() // Snip trailing new line
                    
                    lines = text.components(separatedBy: "\n")
                    
                } catch { print("Error reading file: \(path)") }
                
            }
            
            // Trim Header
            var headerRowCount = 0
            
            for line in lines {
                
                if line.contains(";") { break /*BREAK - first non-header line*/ }
                
                headerRowCount += 1
                
            }
            
            assert(headerRowCount != lines.count,
                   """
                       Unable to find end of header.
                       Something/s wrong. Check header in \(file.name).\(file.type).
                       """)
            
            lines.removeFirst(headerRowCount)
            
            // Process Answers
            for line in lines {
                
                let data        = line.split(separator: ";")
                
                if data.isEmpty { continue /*CONTINUE*/ }
                
                assert(data.count >= 3 && data.count <= 4,
                       "\(line) <-- Error Here")
                
                let digits              = Int(data[0])!.digits
                let difficultyRating    = Int(data[1])!
                let puzzleDate          = String(data[2]).simpleDate
                
                var archivedPuzzle = ArchivedPuzzle(digits: digits,
                                                    date: puzzleDate,
                                                    difficulty: difficultyRating)
                
                if data.count == 4 {
                    
                    let saved       = Int(data[3])!
                    let computed    = PuzzleArchiver.calcPuzzleNum(forDate: puzzleDate)
                    
                    assert(saved    == computed,
                           "Saved(\(saved)) and Computed(\(computed)) Puzzle #'s Do Not Reconcile")
                    
                }
                
                archivedPuzzle.managedID =  archive.add(archivedPuzzle,
                                                        allowDuplicates: false,
                                                        shouldArchive: false )
                
            }
        
        // Save
        save()
        
    }
    
    /// Converts `puzzle` to `ArchviedPuzzle` and archives to `archive` `ManagedCollection`
    /// - Parameter puzzle: `Puzzle` to add to archive.
    private func add(puzzle: ArchivedPuzzle) {
        
        // Add and Save
        archive.add(puzzle,
                    shouldArchive: true)
        
    }
    
    /// Attempts to delete the `ArchivedPuzzle` with digits matching `puzzle` from `archive` if existing
    /// - Parameter puzzleWithDigits: digits for the puzzle to be deleted, digit order is not important.
    /// 
    /// - Returns: Bool indicating if a matching `ArchivedPuzzle` was found and deleted.
    func delete(puzzleWithDigits: Int) -> Bool {
        
        let digits = puzzleWithDigits.digits.sorted()
        
        for archivedPuzzle in archive.values {
            
            if archivedPuzzle.digits.sorted() == digits {
                
                archive.delete(archivedPuzzle)
                
                return true /*EXIT*/
                
            }
            
        }
        
        return false /*EXIT*/
        
    }

    
    /// Deletes all `ArchivedPuzzle`s from `archive`
    /// - Parameter puzzles: <#puzzles description#>
    private func delete(puzzles: [ArchivedPuzzle]) {
        
        puzzles.forEach { archive.delete($0) }
        
    }
    
    /// Confirms that the user wants to save the specified `Puzzle` as an `ArchivedPuzzle`
    /// and if there are existing `ArchivedPuzzle`(s) with same date/puzzleNum also
    /// confirms that they should be overwritten with new this `Puzzle`
    /// - Parameter puzzle: <#puzzle description#>
    ///
    /// - Note: ovewriting deletes all pre-existing `ArchivedPuzzles` with the same
    /// date/puzzleNum
    func confirmSave(_ puzzle: Puzzle?) {
        
        guard let puzzle = puzzle,
              puzzle.isFullySolved
        else { return/*EXIT*/ }
        
        let today = Date().simple.simpleDate
        
        let archivedPuzzle  = ArchivedPuzzle(digits: puzzle.digits,
                                            date: today,
                                            difficulty: puzzle.difficulty!.estimated)
        
        let puzzleNum       = PuzzleArchiver.calcPuzzleNum(forDate: archivedPuzzle.date)
        let existing        = getPuzzlesNumbered(puzzleNum)
        
        if existing.count > 0 {
            
            let existingMapped = existing.map{$0.digits}
            
            Alert.yesno((title: "Overwrite Existing Puzzle?",
                         message: """
                                    Click 'Yes' to overwrite existing puzzle(s) #\(puzzleNum):
                                    \(existingMapped)
                                    with
                                    \(puzzle.digits)
                                    """),
                        yesHandler: {
                _ in
                
                self.delete(puzzles: existing)
                self.add(puzzle: archivedPuzzle)
                
            })
            
        } else {
            
            Alert.yesno((title: "Save Puzzle \(archivedPuzzle.digits)", 
                         message: "Click 'Yes' to save puzzle."),
                        yesHandler: {
                _ in
                
                self.add(puzzle: archivedPuzzle)
                
            })
            
        }
        
    }
    
    /// - Parameter num: puzzle number to match
    /// - Returns: an array `[ArchivedPuzzle]` with `puzzleNumber`s matching `num`
    private func getPuzzlesNumbered(_ num: Int) -> [ArchivedPuzzle] {
        
        var matches = [ArchivedPuzzle]()
        
        for puzzle in archive.values {
            
            if puzzle.puzzleNum == num {
                
                matches.append(puzzle)
                
            }
            
        }
        
        return matches
        
    }
    
    /// Saves `archive` `ManagedCollection`
    private func save() {
        
        archive.save()
        
    }
    
}
