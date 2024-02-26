struct CustomButton: View {
    var title: String
    var backgroundColor: Color
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity, minHeight: 44)
                .font(.headline)
                .foregroundColor(.white)
                .background(backgroundColor)
                .cornerRadius(10)
        }
    }
}
