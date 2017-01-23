import XCTest
@testable import island

class islandTests: XCTestCase {
    
    var map: Map.Matrix!
    
    func testSimple() {
        
        let probability: UInt32 = 50
        let map = RandomMapGenerator(rows: 5, columns: 5, probability: probability).newMap()
        map.draw()
        
        print("start")
        let result = IslandFinder().findIslandsCount(matrix: map)
        print(result)
        print("end")
    }

    
    func testHardCase() {
        
        self.measureMetrics(type(of: self).defaultPerformanceMetrics(), automaticallyStartMeasuring: false, for: {
            let probability: UInt32 = arc4random_uniform(100)
            print("creating map")
            self.map = RandomMapGenerator(rows: 1000, columns: 1000, probability: probability).newMap()
            print("\(Date()) start - probability: \(probability)")
            
            self.startMeasuring()
            let result = IslandFinder().findIslandsCount(matrix: self.map)
            self.stopMeasuring()
            
            print(result)
            print("\(Date()) end")
        })
    }
}
