import XCTest
@testable import FinedustInfo

class FinedustInfoTests: XCTestCase {
    var finedustTestObj : FinedustInfo?
    let expectedImageName : String = "good"
    let expectedGradeName : String = "매우나쁨"

    
    override func setUp() {
        super.setUp()
        finedustTestObj = FinedustInfo(pm10Value: 30, pm10Grade: 1, pm25Value: 90, pm25Grade: 4, dateTime: "2020-05-09 15:00")
    }

    override func tearDown() {
        super.tearDown()
        finedustTestObj = nil
    }
    
    func testsStIndicatorImageName() {
        XCTAssertEqual(FinedustInfo.setIndicatorImageName(data: 1), expectedImageName)
    }
    
//    func testCheckFinedustGrade() {
//        XCTAssertEqual(FinedustInfo.checkFinedustGrade(data: finedustTestObj!.ultraFineDustGrade), expectedGradeName)
//    }

    func testGetFinedustInfoFromJson() {
        
    }
        
    func testPerformanceExample() {
        measure {
        }
    }

}
