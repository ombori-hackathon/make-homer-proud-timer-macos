import SwiftUI

struct SessionTypeIndicator: View {
    let sessionType: SessionType
    let isDisabled: Bool
    let onSelect: (SessionType) -> Void

    var body: some View {
        HStack(spacing: 12) {
            ForEach(SessionType.allCases, id: \.self) { type in
                Button(action: {
                    onSelect(type)
                }) {
                    Text(type.displayName)
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            type == sessionType ? Color.accentColor : Color.clear,
                            in: Capsule()
                        )
                        .foregroundStyle(type == sessionType ? .white : .primary)
                }
                .buttonStyle(.plain)
                .disabled(isDisabled)
            }
        }
        .padding(4)
        .background(.regularMaterial, in: Capsule())
    }
}
