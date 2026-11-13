// Volume, weight, and bag-count math for soil, mulch, and rock

import Foundation

enum Material: String, CaseIterable, Identifiable {
    case soil = "Soil"
    case mulch = "Mulch"
    case rock = "Rock"

    var id: String { rawValue }
}

struct MaterialEstimate {
    static let cubicFeetPerCubicYard = 27.0
    static let litersPerCubicFoot = 28.3168
    /// Typical landscape rock/gravel weight. Real weight varies by stone type and size.
    static let rockPoundsPerCubicYard = 2_800.0
    static let soilBagLiters = 20.0
    static let rockBagPounds = 40.0

    let material: Material
    let cubicYards: Double

    /// Length and width in feet, depth in inches.
    init(material: Material, length: Double, width: Double, depthInches: Double, addCompaction: Bool) {
        var cubicFeet = length * width * (depthInches / 12)

        switch material {
        case .soil: if addCompaction { cubicFeet *= 1.35 }
        case .mulch: cubicFeet *= 0.95
        case .rock: cubicFeet *= 0.85
        }

        self.material = material
        self.cubicYards = cubicFeet / Self.cubicFeetPerCubicYard
    }

    var cubicFeet: Double { cubicYards * Self.cubicFeetPerCubicYard }
    var liters: Double { cubicFeet * Self.litersPerCubicFoot }
    var pounds: Double { cubicYards * Self.rockPoundsPerCubicYard }

    var soilBags: Int { Int((liters / Self.soilBagLiters).rounded(.up)) }
    var rockBags: Int { Int((pounds / Self.rockBagPounds).rounded(.up)) }
}
