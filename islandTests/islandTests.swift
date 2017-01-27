import XCTest
@testable import island

class islandTests: XCTestCase {
    
    func testSimple() {
        
        let percentageOfLand: UInt32 = 30
        let map = MapGenerator(rows: 6, columns: 7, percentageOfLand: percentageOfLand).random()
        map.draw()
        
        print("start")
        let result = IslandFinder(map: map).getCount { p in
            map.draw()
        }
        
        print(result)
        print("end")
    }
    
    func testWorseCase() {
        
        self.measureMetrics(type(of: self).defaultPerformanceMetrics(), automaticallyStartMeasuring: false, for: {
            let percentageOfLand: UInt32 = 80
            let map = MapGenerator(rows: 1000, columns: 1000, percentageOfLand: percentageOfLand).random()
            print("\(Date()) start - percentageOfLand: \(percentageOfLand)")
            
            self.startMeasuring()
            let result = IslandFinder(map: map).getCount()
            self.stopMeasuring()
            
            print(result)
            print("\(Date()) end")
        })
    }
    
    func testNormalCase() {
        
        self.measureMetrics(type(of: self).defaultPerformanceMetrics(), automaticallyStartMeasuring: false, for: {
            let percentageOfLand: UInt32 = 50
            let map = MapGenerator(rows: 1000, columns: 1000, percentageOfLand: percentageOfLand).random()
            print("\(Date()) start - percentageOfLand: \(percentageOfLand)")
            
            self.startMeasuring()
            let result = IslandFinder(map: map).getCount()
            self.stopMeasuring()
            
            print(result)
            print("\(Date()) end")
        })
    }
}
