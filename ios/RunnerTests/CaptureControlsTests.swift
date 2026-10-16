import XCTest

final class CaptureControlsTests: XCTestCase {
  func testBundleHoldsTheRecordControl() {
    XCTAssertTrue(
      String(describing: type(of: CaptureControlsBundle().body)).contains("RecordControl"))
  }

  func testRecordControlIsAStaticControl() {
    XCTAssertTrue(
      String(describing: type(of: RecordControl().body)).contains("StaticControlConfiguration"))
  }

  func testIntentIsNamedForTheControl() {
    XCTAssertEqual(String(localized: RecordWithCaptureIntent.title), "Record with Capture")
  }
}
