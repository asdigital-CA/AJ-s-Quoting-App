// First-launch screen that asks for the user's name and stores it on device

import SwiftUI

struct WelcomeView: View {
    @AppStorage("userName") private var userName = ""
    @State private var nameInput = ""
    @FocusState private var nameFieldFocused: Bool

    private var trimmedName: String {
        nameInput.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("Welcome!")
                .font(.largeTitle)
                .bold()

            Text("Enter your name to get started.")
                .foregroundColor(.secondary)

            TextField("Your name", text: $nameInput)
                .textFieldStyle(.roundedBorder)
                .textContentType(.givenName)
                .submitLabel(.done)
                .focused($nameFieldFocused)
                .onSubmit(saveName)

            Button("Continue", action: saveName)
                .frame(maxWidth: .infinity)
                .buttonStyle(.borderedProminent)
                .disabled(trimmedName.isEmpty)

            Spacer()

            Text("Coded by AS Digital")
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
        .onAppear { nameFieldFocused = true }
    }

    private func saveName() {
        guard !trimmedName.isEmpty else { return }
        userName = trimmedName
    }
}

#Preview {
    WelcomeView()
}
