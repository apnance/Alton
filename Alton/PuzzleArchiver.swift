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
    
    
    /// Returns the number of archived `Puzzle`s
    var count: Int { archive.count }
    
    func byDate() -> [ArchivedPuzzle] {
        
        archive.values.sorted{ $0.date < $1.date }
        
    }
    
    /// Use `shared` singleton
    private init() {
        
        loadArchiveFromDefaults()
        
    }
    
    /// Calculates the All Ten puzzle number for today's date.
    static var todaysPuzzleNumber: Int {
        
        calcPuzzleNum(forDate: Date().simple.simpleDate)
        
    }
    
    /// Calculates the All Ten puzzle number based the specified `forDate`.
    static func calcPuzzleNum(forDate date: Date) -> Int {
        
        date.daysFrom(earlierDate: Configs.Puzzle.originalPuzzleDate) + 1
        
    }
    
    /// Loads archived `ArchivedPuzzle`in `puzzle.default.data.txt` into `archive`
    private func loadArchiveFromDefaults() {
        
        if archive.count > 0 { return /*EXIT*/ }
        
        // Load
        var archivedPuzzles = PuzzleArchiver.loadDefaults()
        
        // Archive
        archive.addEntries(&archivedPuzzles,
                           allowDuplicates: true)
        
        // Save
        save()
        
    }
    
    /// Loads and returns all default puzzle data in puzzle.default.data.txt  as `[ArchivedPuzzle]`
    static func loadDefaults() -> [ArchivedPuzzle] {
        
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
        
        var output = [ArchivedPuzzle]()
        
        // Process Answers
        for line in lines {
            
            let data        = line.split(separator: ";")
            
            if data.isEmpty { continue /*CONTINUE*/ }
            
            assert(data.count >= 3 && data.count <= 4,
                   "\(line) <-- Error Here")
            
            let digits              = Int(data[0])!.digits
            let difficultyRating    = Int(data[1])!
            let puzzleDate          = String(data[2]).simpleDate
            
            let archivedPuzzle      = ArchivedPuzzle(digits: digits,
                                                     date: puzzleDate,
                                                     difficulty: difficultyRating)
            
            output.append(archivedPuzzle)
            
            // Check Actual Puzzle# vs Calculated Puzzle#
            if data.count == 4 {
                
                let saved       = Int(data[3])!
                let computed    = PuzzleArchiver.calcPuzzleNum(forDate: puzzleDate)
                
                assert(saved    == computed,
                       "Saved(\(saved)) and Computed(\(computed)) Puzzle #'s Do Not Reconcile")
                
            }
            
        }
        
        return output
        
    }
    
    /// Converts `puzzle` to `ArchviedPuzzle` and archives to `archive` `ManagedCollection`
    /// - Parameter puzzle: `Puzzle` to add to archive.
    private func add(puzzle: ArchivedPuzzle) {
        
        // Add and Save
        archive.add(puzzle,
                    shouldArchive: true)
        
    }
    
    /// Attempts to add the `ArchivedPuzzle` with digits matching `puzzleNum` to `archive`
    /// - Parameter puzzleWithDigits: digits for the puzzle to be added, digit order is not important.
    /// - Parameter withDate: date of the `ArchivedPuzzle` to be added.
    func add(puzzleWithDigits puzzleNums: Int,
             withDate: Date) {
        
        let solved = Solver(puzzleNums.digits).puzzle
        
        confirmSave(solved, withDate: withDate)
        
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
    
    /// Deletes all specified `ArchivedPuzzle`s from `archive`
    /// - Parameter puzzles: array of `ArchivePuzzle`s to delete from archive.
    private func delete(puzzles: [ArchivedPuzzle]) {
        
        puzzles.forEach { archive.delete($0) }
        
    }
    
    /// Wipes out archive and reloads default puzzle data.
    func nuke() {
        
//        HERE...
//        BUG: Alton is unable to find a solution for answer 2 for puzzle 3799 from 7/19/24
        // FIXME: Alton is unable to find a solution for answer 2 for puzzle 3799 from 7/19/24
        
        // TODO: Clean Up - use alert to confirm this action.
        archive.reset()
        loadArchiveFromDefaults()
        
    }
    
    /// Confirms that the user wants to save the specified `Puzzle` as an `ArchivedPuzzle`
    /// and if there are existing `ArchivedPuzzle`(s) with same date/puzzleNum also
    /// confirms that they should be overwritten with new this `Puzzle`
    /// - Parameter puzzle: `Puzzle` to confirm saving to archive.
    ///
    /// - Note: ovewriting deletes all pre-existing `ArchivedPuzzles` with the same
    /// date/puzzleNum
    func confirmSave(_ puzzle: Puzzle?, 
                     withDate date: Date? = nil) {
        
        guard let puzzle = puzzle,
              puzzle.isFullySolved
        else { return/*EXIT*/ }
        
        // Check Archive
        if isArchived(puzzle) { return /*EXIT*/ }
        
        let archivedDate = date ?? Date().simple.simpleDate
        
        let archivedPuzzle  = ArchivedPuzzle(digits: puzzle.digits,
                                             date: archivedDate,
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
    
    
    /// Checks for `Puzzle`s digits in the `archive` returning true if found, else false.
    /// - Parameter toCheck: `Puzzle` who's digits should be checked against
    /// archived `Puzzle`'s digits.
    ///
    /// - Returns: Bool indicating if the specified Puzzle's digits match any archived Puzzles
    ///
    /// - important: `Puzzle` digits are sorted before being compared.
    private func isArchived(_ toCheck: Puzzle ) -> Bool {
        
        let sortedDigitsToCheck = toCheck.digits.sorted()
        
        for puzzle in archive.values {
            
            if puzzle.digits.sorted() == sortedDigitsToCheck {
                
                return true /*EXIT*/
                
            }
            
        }
        
        return false /*EXIT*/
        
    }
    
    /// Saves `archive` `ManagedCollection`
    private func save() {
        
        archive.save()
        
    }
    
}

// - MARK: Diagnostics
extension PuzzleArchiver {
    
    
    /// Finds all duplicate including `ArchivedPuzzle`s with the same date but
    ///  different digits and `ArchivedPuzzle`s with the same digits but different dates.
    ///
    /// - Returns: Tuple composed of list of puzzles that have same digits and a list
    /// of puzzles that have the same dates.
    func findDupes() -> (digits:[Int : [ArchivedPuzzle]], dates : [Date : [ArchivedPuzzle]]) {
        
        var byDate  = [Date : [ArchivedPuzzle]]()
        var byDigit = [Int : [ArchivedPuzzle]]()
        
        var dupeDate    = [Date]()
        var dupeDigit   = [Int]()
        
        for value in archive.values {
            
            let date    = value.date
            let digits  = value.digits.sorted().asInt()!
            
            if byDate[date] == nil {
                
                byDate[date] = [ArchivedPuzzle]()
                
            }
            
            if byDigit[digits] == nil {
                
                byDigit[digits] = [ArchivedPuzzle]()
                
            }
            
            byDate[date]!.append(value)
            if byDate[date]!.count > 1 { dupeDate.append(date) }
            
            byDigit[digits]!.append(value)
            if byDigit[digits]!.count > 1 { dupeDigit.append(digits) }
            
        }
        
        var byDateDupes = [Date : [ArchivedPuzzle]]()
        dupeDate.forEach{ byDateDupes[$0] = byDate[$0] }
        
        var byDigitDupes = [Int : [ArchivedPuzzle]]()
        dupeDigit.forEach{ byDigitDupes[$0] = byDigit[$0] }
        
        return (byDigitDupes, byDateDupes)
        
    }
    
    
    /// Performs diagnostic test returning resulting report as `String`
    /// - Returns: diagnostic report.
    func diagnose() -> String {
        
        let (byDigit, byDate) = PuzzleArchiver.shared.findDupes()
        
        var digitOutput = "  Digits(\(byDigit.count)):\n"
        var dateOutput  = "  Dates(\(byDate.count)):\n"
        
        if byDigit.count > 0 || byDate.count > 0 {
            
            for key in byDigit.keys.sorted() {
                
                digitOutput += "\t* [\(key)]\n"
                
                for puzz in byDigit[key]! {
                    
                    digitOutput += "\t\(puzz)\n"
                    
                }
                
                digitOutput += "\n"
                
            }
            
            for key in byDate.keys.sorted() {
                
                dateOutput += "\t* \(key.simple)\n"
                
                for puzz in byDate[key]! {
                    
                    dateOutput += "\t\(puzz)\n"
                    
                }
                
                dateOutput += "\n"
                
            }
            
        }
        
        return """
                Duplicates:
                \(digitOutput)
                \(dateOutput)
                
                """
        
    }
    
}
