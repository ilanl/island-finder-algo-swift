import UIKit

class RandomMapGenerator{
    
    var map: Map.Matrix
    
    init(rows:Int, columns:Int) {
        self.map = Map.Matrix(rows: rows, columns: columns)
    }
    
    func newMap() -> Map.Matrix{
        
        for r in 0...self.map.maxRowIndex{
            for c in 0...self.map.maxColumnIndex{
                if arc4random_uniform(30)%4 == 0{ //Change randomness
                    var p = self.map[r,c]!
                    if p.color == Map.Color.water{
                        p.color = Map.Color.land
                        self.map[r,c] = p
                    }
                }
            }
        }
        return self.map
    }
}


class Map{
    
    struct Notifications{
        static let PointVisitedNotification:Notification.Name = Notification.Name(rawValue: "PointVisitedNotification")
    }
    
    enum Color{
        case land, water, visited
    }
    
    struct Point{
        var color: Map.Color = .water{
            didSet{
                if (self.color == Map.Color.visited && oldValue != self.color){
                    NotificationCenter.default.post(Notification(name: Notifications.PointVisitedNotification))
                }
            }
        }
        init(color: Map.Color? = Map.Color.water) {
            self.color = color!
        }
    }
    
    class Matrix {
        let rows: Int, columns: Int
        private var grid: [Point]
        
        init(rows: Int, columns: Int) {
            self.rows = rows
            self.columns = columns
            grid = Array(repeating: Point(), count: rows * columns)
            
            let nc = NotificationCenter.default
            nc.addObserver(forName:Notifications.PointVisitedNotification,
                           object:nil, queue:nil) {
                            notification in
                            
                            self.draw()
                            print("--------------------------------")
            }
        }
        
        var maxRowIndex: Int{
            get{
                return self.rows-1
            }
        }
        
        var maxColumnIndex: Int{
            get{
                return self.columns-1
            }
        }
        
        subscript(index: Int) -> Point?{
            get{
                if !indexIsValid(index: index) {
                    return nil
                }
                return grid[index]
            }
            set{
                if (indexIsValid(index: index)){
                    grid[index] = newValue!
                }
            }
        }
        
        subscript(row: Int, column: Int) -> Point? {
            get {
                if !indexIsValid(row: row, column: column){
                    return nil
                }
                return grid[(row * columns) + column]
            }
            set {
                if indexIsValid(row: row, column: column){
                    grid[(row * columns) + column] = newValue!
                }
            }
        }
        
        //MARK: -
        //MARK: Private methods
        private func indexIsValid(row: Int, column: Int) -> Bool {
            return row >= 0 && row <= self.maxRowIndex && column >= 0 && column <= self.maxColumnIndex
        }
        
        private func indexIsValid(index: Int) -> Bool {
            return index >= 0 && index < (self.rows * self.columns)
        }
        
        func getLandNeighbors(row: Int, column: Int) -> [(Point, Int, Int)]{
            
            var results:[(Point, Int, Int)] = []
            
            //nn, ne, clock-wise loop in land neighbors
            for coords in [(row-1,column),(row-1,column+1),(row,column+1),(row+1,column+1),(row+1,column),(row+1,column-1),(row,column-1),(row-1,column-1)]{
                if let p = self[coords.0,coords.1]{
                    if (p.color == Map.Color.land){
                        results.append((p, coords.0, coords.1))
                    }
                }
            }
            
            return results
        }
        
        func draw(){
            for r in 0...self.maxRowIndex{
                for c in 0...self.maxColumnIndex{
                    if let p = self[r,c]{
                        if (p.color == Map.Color.water){
                            print("🌀", terminator: "")
                        }
                        else if (p.color == Map.Color.land){
                            print("🍺", terminator: "")
                        }
                        else {
                            print("❌", terminator: "")
                        }
                    }
                    if c == self.maxColumnIndex{
                        print("", terminator: "\n")
                    }
                }
                
            }
        }
    }
}

class IslandFinder{
    
    func findIslandsCount(matrix: Map.Matrix) -> Int{
        
        var numIslands: Int = 0
        for r in 0...matrix.maxRowIndex {
            for c in 0...matrix.maxColumnIndex {
                var p = matrix[r,c]!
                if(p.color == Map.Color.land) {
                    findConnectedIslands(i: r,j: c, matrix: matrix)
                    numIslands = numIslands + 1
                }
                else {
                    p.color = Map.Color.visited
                }
            }
        }
        return numIslands
    }
    
    private func findConnectedIslands(i:Int, j:Int, matrix:Map.Matrix) -> Void{
        
        matrix[i,j]!.color = Map.Color.visited
        for p in matrix.getLandNeighbors(row: i, column: j) {
            if (p.0.color == Map.Color.land){
                findConnectedIslands(i: p.1, j: p.2, matrix: matrix)
            }
        }
    }
}



