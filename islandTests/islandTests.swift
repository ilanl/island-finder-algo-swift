import XCTest
@testable import island

class islandTests: XCTestCase {
    
    func testIslandFinder() {
        
        let map = RandomMapGenerator(rows: 5, columns: 5).newMap()
        map.draw()
        
        print("start")
        let result = IslandFinder().findIslandsCount(matrix: map)
        print(result)
        print("end")
    }
}
