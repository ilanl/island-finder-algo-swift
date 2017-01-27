import XCTest
@testable import island

class islandTests: XCTestCase {
    
    func testSimple() {
        
        let probability: UInt32 = 60
        let map = RandomMapGenerator(rows: 10, columns: 10, probability: probability).newMap()
        map.draw()
        
        print("start")
        let result = IslandFinder(map: map).findIslandsCount { p in
            //Draw each change in map
            map.draw()
        }
        
        print(result)
        print("end")
    }

    
    func testHardCase() {
        
        self.measureMetrics(type(of: self).defaultPerformanceMetrics(), automaticallyStartMeasuring: false, for: {
            let probability: UInt32 = arc4random_uniform(100)
        
            let map = RandomMapGenerator(rows: 1000, columns: 1000, probability: probability).newMap()
            print("\(Date()) start - probability: \(probability)")
            
            self.startMeasuring()
            let result = IslandFinder(map: map).findIslandsCount()
            self.stopMeasuring()
            
            print(result)
            print("\(Date()) end")
        })
    }
}
