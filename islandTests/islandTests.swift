import XCTest
@testable import island

class islandTests: XCTestCase {
    
    func testIslandFinder() {
        
        let map = RandomMapGenerator(rows: 10, columns: 10).newMap()
        map.draw()
        
        print("start")
        let result = IslandFinder().findIslandsCount(matrix: map)
        print(result)
        print("end")
    }
}
