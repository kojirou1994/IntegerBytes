import XCTest
import IntegerBytes

final class IntegerBytesTests: XCTestCase {

  let number: UInt64 = 0x12345678_87654321

  let bigEndianBytes: Data = .init([
    0x12, 0x34, 0x56, 0x78,
    0x87, 0x65, 0x43, 0x21
  ])

  func testIntegerBytes() {
    var bytes = IntegerBytes(number, endian: .little)
    XCTAssertEqual(bytes.count, MemoryLayout<UInt64>.size)
    XCTAssertEqual(bytes.startIndex, 0)
    XCTAssertEqual(bytes.endIndex, MemoryLayout<UInt64>.size)
    XCTAssertEqual(bytes[0], 0x21)
    bytes[0] = 0x00
    XCTAssertEqual(bytes[0], 0x00)
    let newNumber: UInt64 = 0x12345678_87654300
    XCTAssertEqual(bytes.value, newNumber)
    bytes.withContiguousStorageIfAvailable { buffer in
      var v: UInt64 = 0
      _ = withUnsafeMutableBytes(of: &v, buffer.copyBytes)
      XCTAssertEqual(v, newNumber)
    }

    XCTAssertTrue(IntegerBytes(number, endian: .big).elementsEqual(bigEndianBytes))
    XCTAssertTrue(IntegerBytes(number, endian: .little).elementsEqual(bigEndianBytes.reversed()))
  }

  func testIntegerToBytes() {
    let littleEndianBytes = Data(bigEndianBytes.reversed())
    XCTAssertEqual(number.toBytes(endian: .big), bigEndianBytes)
    XCTAssertEqual(number.toBytes(endian: .little), littleEndianBytes)

  }
}
