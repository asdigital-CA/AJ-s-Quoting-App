// Volume calculator for soil, mulch, and rock

import SwiftUI

struct ContentView: View {
    @AppStorage("userName") private var userName = ""
    @State private var length: String = ""
    @State private var width: String = ""
    @State private var depth: String = ""
    @State private var material: Material = .soil
    @State private var addCompaction = false
    @State private var estimate: MaterialEstimate?
    @State private var errorMessage: String = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    areaInputSection
                    materialTypeSection
                    if material == .soil { soilOptionsSection }
                    calculateButton
                    if !errorMessage.isEmpty { Text(errorMessage).foregroundColor(.red) }
                    if let estimate { volumeOutputSection(estimate) }
                    footerSection
                }
                .padding()
            }
            .navigationTitle("Welcome, \(userName)!")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        userName = ""
                    } label: {
                        Image(systemName: "person.crop.circle")
                    }
                    .accessibilityLabel("Change name")
                }
            }
        }
    }

    var areaInputSection: some View {
        Group {
            Text("Enter Area Dimensions").font(.headline)
            TextField("Length (ft)", text: $length).textFieldStyle(.roundedBorder).keyboardType(.decimalPad)
            TextField("Width (ft)", text: $width).textFieldStyle(.roundedBorder).keyboardType(.decimalPad)
            TextField("Depth (inches)", text: $depth).textFieldStyle(.roundedBorder).keyboardType(.decimalPad)
        }
    }

    var materialTypeSection: some View {
        Group {
            Text("Material Type").font(.headline)
            Picker("Material", selection: $material) {
                ForEach(Material.allCases) { Text($0.rawValue).tag($0) }
            }
            .pickerStyle(.segmented)
            .onChange(of: material) { estimate = nil }
        }
    }

    var soilOptionsSection: some View {
        Toggle("Add 35% for compaction", isOn: $addCompaction)
            .onChange(of: addCompaction) { estimate = nil }
    }

    var calculateButton: some View {
        Button("Calculate Volume") {
            UIApplication.shared.endEditing()
            calculateVolume()
        }
        .padding(.top, 10)
        .frame(maxWidth: .infinity)
        .buttonStyle(.borderedProminent)
    }

    func volumeOutputSection(_ estimate: MaterialEstimate) -> some View {
        Group {
            Text("Estimated Volume").font(.headline)
            Text("\(format(estimate.cubicYards, decimals: 2)) cubic yards")

            switch estimate.material {
            case .soil:
                Text("\(format(estimate.liters)) liters")
                Text("≈ \(estimate.soilBags) bags (20 L)").bold()
            case .mulch:
                Text("\(format(estimate.cubicFeet, decimals: 1)) cubic feet")
                Text("\(format(estimate.liters)) liters")
            case .rock:
                Text("\(format(estimate.pounds)) lbs")
                Text("≈ \(estimate.rockBags) bags (40 lb)").bold()
            }
        }
    }

    func format(_ value: Double, decimals: Int = 0) -> String {
        value.formatted(.number.precision(.fractionLength(decimals)))
    }

    var footerSection: some View {
        Text("Coded by AS Digital")
            .font(.footnote)
            .foregroundColor(.gray)
            .padding(.top, 40)
    }

    func calculateVolume() {
        guard let l = Double(length), let w = Double(width), let d = Double(depth) else {
            estimate = nil
            errorMessage = "Please enter valid numbers."
            return
        }

        errorMessage = ""
        estimate = MaterialEstimate(material: material, length: l, width: w, depthInches: d, addCompaction: addCompaction)
    }
}

#Preview {
    ContentView()
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
