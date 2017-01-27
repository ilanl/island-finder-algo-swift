import UIKit

class RandomMapGenerator{
    
    var map: Map
    var probability: UInt32 = 100
    
    init(rows:Int, columns:Int, probability: UInt32) {
        self.map = Map(rows: rows, columns: columns)
        self.probability = probability
    }
    
    func newMap() -> Map{
        
        for r in 0...self.map.maxRowIndex{
            for c in 0...self.map.maxColumnIndex{
                
                let p = Point()
                p.isLand = arc4random_uniform(100) > self.probability
                p.x = r
                p.y = c
                self.map[r,c] = p
            }
        }
        return self.map
    }
}

class Head{
    
    var color: UIColor
    var numericValue: Int
    init(number: Int, color: UIColor){
        self.numericValue = number
        self.color = color
    }
}

class Point{
    
    var head: Head?
    var isLand: Bool = false
    var x:Int = 0
    var y:Int = 0
    
    func getColor() -> UIColor{
        guard let color = head?.color else {
            return isLand ? UIColor.black : UIColor.white
        }
        return color
    }
}

class Map {
    let rows: Int, columns: Int
    private var grid: [Point?]
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = [Point?](repeating: Point(), count:rows*columns)
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
    
    public subscript(index: Int) -> Point?{
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
    
    public subscript(row: Int, column: Int) -> Point? {
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
    
    func getLandNeighbors(row: Int, column: Int) -> [Point]{
        
        var results:[Point] = []
        
        //TODO: Ilan
        for coords in [(row-1,column),(row-1,column+1),(row,column+1),(row+1,column+1),(row+1,column),(row+1,column-1),(row,column-1),(row-1,column-1)]{
            if let p = self[coords.0,coords.1]{
                if (p.isLand){
                    results.append(p)
                }
            }
        }
        
        return results
    }
    
    func draw(){
        
        for r in 0...self.maxRowIndex{
            for c in 0...self.maxColumnIndex{
                if let p = self[r,c]{
                    //TODO: Ilan
                    if let _ = p.head {
                        print("❌", terminator: "")
                    }
                    else{
                        if (!p.isLand){
                            print("🌀", terminator: "")
                        }
                        else if (p.isLand){
                            print("🍺", terminator: "")
                        }
                    }
                }
                if c == self.maxColumnIndex{
                    print("", terminator: "\n")
                }
            }
            
        }
        print("\n")
    }
}

class IslandFinder{
    
    var map: Map!
    
    init(map: Map) {
        self.map = map
    }
    
    func findIslandsCount(onChange:((_ pointChanged: Point)->())? = nil) -> Int{
        
        var networks:[Int:Int] = [:]
        var networkCounter:Int = 0
        
        for r in 0...map.maxRowIndex {
            
            for c in 0...map.maxColumnIndex {
                
                guard let currentPoint = map[r,c] else { assertionFailure("out of bounds failure"); return 0}
                
                guard currentPoint.isLand else { continue }
                
                if currentPoint.head == nil{
                    networkCounter = networkCounter + 1
                    currentPoint.head = Head(number: networkCounter, color: UIColor.red) //TODO generate color
                    networks[networkCounter] = networkCounter //new network detected
                    
                    onChange?(currentPoint)
                }
                
                for neighborPoint in map.getLandNeighbors(row: currentPoint.x, column: currentPoint.y){
                    
                    if neighborPoint.head == nil{
                        neighborPoint.head = currentPoint.head
                    }
                    else if !(neighborPoint.head! === currentPoint.head!){
                        
                        if (neighborPoint.head!.numericValue > currentPoint.head!.numericValue){
                            //absorb network neighbor
                            networks[neighborPoint.head!.numericValue] = nil
                            onChange?(neighborPoint)
                        }
                        else{
                            //absorb network neighbor
                            networks[currentPoint.head!.numericValue] = nil
                            onChange?(currentPoint)
                        }
                    }
                }
            }
        }
        
        return networks.count
    }
}

//MARK: Other way

//
//class NetworkStack {
//    var items:[Map.Point] = []
//
//    func peek() -> Map.Point?{
//        return items.last
//    }
//
//    func push(_ item: Map.Point) {
//        items.append(item)
//    }
//
//    func pop() -> Map.Point {
//        return items.removeLast()
//    }
//}



//class IslandFinder{
//
//    var Map: Map!
//    var stack: NetworkStack!
//
//    func findIslandsCount(Map: Map) -> Int{
//
//        self.Map = Map
//        self.stack = NetworkStack()
//
//        var numIslands: Int = 0
//        for r in 0...Map.maxRowIndex {
//            for c in 0...Map.maxColumnIndex {
//                let p = Map[r,c]!
//                if(p.color == Map.Color.land) {
//                    findConnectedIslands(i: r,j: c)
//                    numIslands = numIslands + 1
//                }
//            }
//        }
//        return numIslands
//    }
//
//    private func findConnectedIslands(i:Int, j:Int){
//
//        let point = Map[i,j]!
//        point.color = Map.Color.visited
//        stack.push(point)
//
//        while(stack.peek() != nil){
//            let p = stack.peek()!
//            let neighbors = Map.getLandNeighbors(row: p.x!, column: p.y!)
//            if neighbors.count > 0{
//                for coords in neighbors{
//                    let p1 = Map[coords.x!,coords.y!]!
//                    p1.color = .visited
//                    stack.push(p1)
//                }
//            }
//            else{
//                let _ = stack.pop()
//            }
//        }
//    }
//}

