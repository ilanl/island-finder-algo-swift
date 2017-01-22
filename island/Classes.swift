import UIKit

class RandomMapGenerator{
    
    var map: Map.Matrix
    var probability: UInt32 = 100
    
    init(rows:Int, columns:Int, probability: UInt32) {
        self.map = Map.Matrix(rows: rows, columns: columns)
        self.probability = probability
    }
    
    func newMap() -> Map.Matrix{
        
        for r in 0...self.map.maxRowIndex{
            for c in 0...self.map.maxColumnIndex{
                let isLand = arc4random_uniform(100) > self.probability
                let p = Map.Point(color: isLand ? .land : .water)
                p.x = r
                p.y = c
                self.map[r,c] = p
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
    
    class Point{
        var x:Int?
        var y:Int?
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
        private var grid: [Point?]
        
        init(rows: Int, columns: Int) {
            self.rows = rows
            self.columns = columns
            grid = [Point?](repeating: nil, count:rows*columns)
            
            let nc = NotificationCenter.default
            nc.addObserver(forName:Notifications.PointVisitedNotification,
                           object:nil, queue:nil) {
                            notification in
                            
                            self.draw()
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
        
        func getLandNeighbors(row: Int, column: Int) -> [(Int, Int)]{
            
            var results:[(Int, Int)] = []
            
            //nn, ne, clock-wise loop in land neighbors
            for coords in [(row-1,column),(row-1,column+1),(row,column+1),(row+1,column+1),(row+1,column),(row+1,column-1),(row,column-1),(row-1,column-1)]{
                if let p = self[coords.0,coords.1]{
                    if (p.color == Map.Color.land){
                        results.append(coords)
                    }
                }
            }
            
            return results
        }
        
        func draw(){
//            for r in 0...self.maxRowIndex{
//                for c in 0...self.maxColumnIndex{
//                    if let p = self[r,c]{
//                        if (p.color == Map.Color.water){
//                            print("🌀", terminator: "")
//                        }
//                        else if (p.color == Map.Color.land){
//                            print("🍺", terminator: "")
//                        }
//                        else {
//                            print("❌", terminator: "")
//                        }
//                    }
//                    if c == self.maxColumnIndex{
//                        print("", terminator: "\n")
//                    }
//                }
//                
//            }
            //print("\n")
        }
    }
}

class IslandFinder{
    
    var matrix: Map.Matrix!
    var stack: GraphStack!
    
    func findIslandsCount(matrix: Map.Matrix) -> Int{
        
        self.matrix = matrix
        self.stack = GraphStack()
        
        var numIslands: Int = 0
        for r in 0...matrix.maxRowIndex {
            for c in 0...matrix.maxColumnIndex {
                let p = matrix[r,c]!
                if(p.color == Map.Color.land) {
                    findConnectedIslands(i: r,j: c)
                    numIslands = numIslands + 1
                }
            }
        }
        return numIslands
    }
    
    private func findConnectedIslands(i:Int, j:Int){
        
        let point = matrix[i,j]!
        point.color = Map.Color.visited
        stack.push(point)
        
        while(stack.peek() != nil){
            let p = stack.peek()!
            let neighbors = matrix.getLandNeighbors(row: p.x!, column: p.y!)
            if neighbors.count > 0{
                for coords in neighbors{
                    let p1 = matrix[coords.0,coords.1]!
                    p1.color = .visited
                    stack.push(p1)
                }
            }
            else{
                let _ = stack.pop()
            }
        }
    }
}

struct GraphStack {
    var items:[Map.Point] = []
    
    func peek() -> Map.Point?{
        return items.last
    }
    
    mutating func push(_ item: Map.Point) {
        items.append(item)
    }
    
    mutating func pop() -> Map.Point {
        return items.removeLast()
    }
}



