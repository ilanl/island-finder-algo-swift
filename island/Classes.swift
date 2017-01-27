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
                p.isLand = arc4random_uniform(100) < self.probability
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
    var emoji: String?
    
    init(number: Int, color: UIColor, emoji: String?){
        self.numericValue = number
        self.color = color
        self.emoji = emoji
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
    private var grid: [Point]
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = [Point](repeating: Point(), count:rows*columns)
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
    
    //MARK: Reset all point network markings to re-run finder on same map
    public func reset(){
        for r in 0...self.maxRowIndex{
            for c in 0...self.maxColumnIndex{
                if let p = self[r,c], p.isLand == true {
                    p.head = nil
                }
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
        
        for coords in [(row-1,column-1),(row-1,column),(row-1,column+1),(row,column+1)]{
            if let p = self[coords.0,coords.1], p.isLand == true{
                results.append(p)
            }
        }
        
        return results
    }
    
    func draw(){
        
        for r in 0...self.maxRowIndex{
            for c in 0...self.maxColumnIndex{
                
                if let p = self[r,c]{
                    
                    if let head = p.head {
                        print(head.emoji, terminator: "")
                    }
                    else if p.isLand {
                        print("🍺", terminator: "")
                    }
                    else {
                        print("🌀", terminator: "")
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
    
    func getCount(onChange:((_ pointChanged: Point)->())? = nil) -> Int{
        
        var networks:[Int:Int] = [:]
        var networkCounter:Int = 0
        let emojiStack = EmojiStack()
        
        for r in 0...map.maxRowIndex {
            
            for c in 0...map.maxColumnIndex {
                
                guard let currentPoint = map[r,c] else { assertionFailure("out of bounds failure"); return 0}
                
                guard currentPoint.isLand == true else { continue }
                
                if currentPoint.head == nil{
                    networkCounter = networkCounter + 1
                    currentPoint.head = Head(number: networkCounter, color: UIColor.red, emoji: emojiStack.pop()) //TODO generate color
                    networks[networkCounter] = networkCounter //new network detected
                    onChange?(currentPoint)
                }
                
                for neighborLandPoint in map.getLandNeighbors(row: currentPoint.x, column: currentPoint.y){
                    
                    if neighborLandPoint.head == nil{
                        neighborLandPoint.head = currentPoint.head
                        onChange?(neighborLandPoint)
                    }
                    else if !(neighborLandPoint.head! === currentPoint.head!){
                        
                        if (neighborLandPoint.head!.numericValue > currentPoint.head!.numericValue){
                            networks[neighborLandPoint.head!.numericValue] = nil
                            neighborLandPoint.head! = currentPoint.head!
                            onChange?(neighborLandPoint)
                        }
                        else{
                            networks[currentPoint.head!.numericValue] = nil
                            currentPoint.head! = neighborLandPoint.head!
                            onChange?(currentPoint)
                        }
                    }
                }
            }
        }
        
        return networks.count
    }
}

class EmojiStack {
    var emojis:[String] = ["❌","❎","🅰","🆎","🆒","🆔","🆚","🈯","🌾","🍚","🍜","🍝","🍞","🍟","🍡","🍵","🍸","🎀","🎁","🎂","🎃","🎄","🎾","🐍","🐵","🐶","🐷","🐸","🐹","🐺","🐻","👀","👙","👶","👿","💉","💊","💚","💛","💜","💩","💪","💰","🔑"]
    
    func peek() -> String?{
        return emojis.last
    }
    
    func pop() -> String? {
        guard (peek() != nil) else { return nil}
        return emojis.removeLast()
    }
}

