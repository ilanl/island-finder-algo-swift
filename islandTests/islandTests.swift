import XCTest
@testable import island

class islandTests: XCTestCase {
    
    func testEasyCase() {
        
        let probability: UInt32 = 90
        self.measure({
            let map = RandomMapGenerator(rows: 1000, columns: 1000, probability: probability).newMap()
            
            print("start")
            let result = IslandFinder().findIslandsCount(matrix: map)
            print(result)
            print("end")
        })
    }
    
    func testMediumCase() {
        
        let probability: UInt32 = 60
        self.measure({
            let map = RandomMapGenerator(rows: 1000, columns: 1000, probability: probability).newMap()
            
            print("start")
            let result = IslandFinder().findIslandsCount(matrix: map)
            print(result)
            print("end")
        })
    }
    
    func testHardCase() {
        
        let probability: UInt32 = 10
        self.measure({
            let map = RandomMapGenerator(rows: 1000, columns: 1000, probability: probability).newMap()
            
            print("start")
            let result = IslandFinder().findIslandsCount(matrix: map)
            print(result)
            print("end")
        })
    }
    
}
