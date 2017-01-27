import XCTest
@testable import island

class islandTests: XCTestCase {
    
    func testSimple() {
        
        let probability: UInt32 = 90
        let map = RandomMapGenerator(rows: 6, columns: 7, probability: probability).newMap()
        map.draw()
        
        print("start")
        let result = IslandFinder(map: map).getCount { p in
            //Draw each change in map
            map.draw()
        }
        
        print(result)
        print("end")
        
        print("reset")
        map.reset()
        map.draw()
    }

    
    func testHardCase() {
        
        self.measureMetrics(type(of: self).defaultPerformanceMetrics(), automaticallyStartMeasuring: false, for: {
            let probability: UInt32 = 80
            let map = RandomMapGenerator(rows: 1000, columns: 1000, probability: probability).newMap()
            print("\(Date()) start - probability: \(probability)")
            
            self.startMeasuring()
            let result = IslandFinder(map: map).getCount()
            self.stopMeasuring()
            
            print(result)
            print("\(Date()) end")
        })
    }
}
