import Endianness

public struct IntegerBytes<T: FixedWidthInteger> {

  /// interger value with host byte order
  public var value: T

  public init(_ value: T, endian: Endianness = .host) {
    self.value = endian == .host ? value : value.byteSwapped
  }

}

extension IntegerBytes: MutableCollection, RandomAccessCollection {

  @inlinable
  public var count: Int { MemoryLayout<T>.size }

  @inlinable
  public var startIndex: Int { 0 }

  @inlinable
  public var endIndex: Int { count }

  @inlinable
  public func index(after i: Int) -> Int {
    assert(i <= endIndex)
    return i + 1
  }

  @inlinable
  public subscript(position: Int) -> UInt8 {
    get {
      withUnsafeBytes(of: value) { buffer in
        buffer[position]
      }
    }
    set {
      withUnsafeMutableBytes(of: &value) { buffer in
        buffer[position] = newValue
      }
    }
  }

  @inlinable
  public func withContiguousStorageIfAvailable<R>(_ body: (UnsafeBufferPointer<UInt8>) throws -> R) rethrows -> R? {
    try withUnsafeBytes(of: value) { try body($0.bindMemory(to: UInt8.self)) }
  }

}

import struct Foundation.Data

extension FixedWidthInteger {

  @inlinable
  public func toBytes(endian: Endianness = .big) -> Data {
    withUnsafeBytes(of: endian == .host ? self : self.byteSwapped) { buffer in
      Data(buffer)
    }
  }
}

/*
extension Sequence where Element == UInt8 {

  public func joinedInteger<T>(endian: Endianness = .big, _ type: T.Type = T.self) -> T where T : FixedWidthInteger {
    let byteCount = MemoryLayout<T>.size
    var result: T = 0
    for element in enumerated() {
      if element.offset == byteCount {
        break
      }
      switch endian {
      case .little:
        result = result | (T(truncatingIfNeeded: element.element) << (element.offset * 8))
      case .big:
        result = (result << 8) | T(truncatingIfNeeded: element.element)
      }
    }
    return result
  }

}
*/
