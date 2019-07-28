import Foundation

extension UInt32 {
    static let none:        UInt32 = 0b000000
    static let player:      UInt32 = 0b000001
    static let floor:       UInt32 = 0b000010
    static let platform:    UInt32 = 0b000100
    static let candy:       UInt32 = 0b001000
    static let checkpoint:  UInt32 = 0b010000
    static let pit:         UInt32 = 0b100000
    
    init(_ categories: UInt32...) {
        self = categories.reduce(0, |)
    }
    
    func compare(to bitmask: UInt32) -> Bool {
        return self & bitmask != 0
    }
    
    func removing(bits bitmask: UInt32) -> UInt32 {
        return self & (~bitmask)
    }
}
