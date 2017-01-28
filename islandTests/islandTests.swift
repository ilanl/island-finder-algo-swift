import XCTest
@testable import island

class islandTests: XCTestCase {
    
    func testDebug(){
        let str = "~,*,~,~,~,~,~,~,~,~,~,~,~,~,~,~,*,~,~,~,*,~,~,*,*,~,*,~,~,~,~,*,~,~,~,~,~,~,~,*,*,~,~,~,~,~,*,~,*,~,*,~,*,~,*,~,~,~,*,*,*,~,*,~,~,*,*,~,*,~,~,~,~,~,*,~,~,*,*,~,~,~,~,*,~,~,~,~,~,~,*,~,*,~,~,*,~,~,~,~"
        
        let map = Map(rows: 10, columns: 10, str: str)
        map.draw()
        
        print("start")
        let result = IslandFinder(map: map).getCount { p in
            map.draw()
        }
        
        print(result)
        print("end")
        
        XCTAssert(result == 9)
    }
    
    func testSimple() {
        
        let percentageOfLand: UInt8 = 60
        let map = MapGenerator(rows: 10, columns: 10, percentageOfLand: percentageOfLand).random()
        map.draw()
        
        print("start")
        let result = IslandFinder(map: map).getCount { p in
            //map.draw()
        }
        
        print(result)
        print("end")
    }
    
    func testWorseCase() {
        
        self.measureMetrics(type(of: self).defaultPerformanceMetrics(), automaticallyStartMeasuring: false, for: {
            let percentageOfLand: UInt8 = 80
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
            let percentageOfLand: UInt8 = 50
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
