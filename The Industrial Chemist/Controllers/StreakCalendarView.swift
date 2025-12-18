import SwiftUI

struct StreakCalendarView: View {

    let activeDays: Set<Int>
    let freezeDays: Set<Int>

    @State private var currentDate = Date()
    @State private var flamePulse = false

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 14), count: 7)

    // MARK: - Derived values
    private var today: Int {
        Calendar.current.component(.day, from: Date())
    }

    private var isCurrentMonth: Bool {
        Calendar.current.isDate(Date(), equalTo: currentDate, toGranularity: .month)
    }

    private var daysInMonth: Int {
        Calendar.current.range(of: .day, in: .month, for: currentDate)?.count ?? 30
    }

    private var monthTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentDate)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {

            // MARK: - Header
            HStack {
                Text(monthTitle)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)

                Spacer()

                Image(systemName: "chevron.left")
                    .foregroundColor(.gray)
                    .onTapGesture { changeMonth(-1) }

                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .onTapGesture { changeMonth(1) }
            }

            // MARK: - Weekdays
            LazyVGrid(columns: columns) {
                ForEach(["Su","Mo","Tu","We","Th","Fr","Sa"], id: \.self) {
                    Text($0)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
            }

            // MARK: - Dates
            LazyVGrid(columns: columns, spacing: 18) {
                ForEach(1...daysInMonth, id: \.self) { day in
                    dayCell(day)
                }
            }

        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color(red: 75/255, green: 43/255, blue: 119/255))
        )
        .padding(.horizontal, 16)
    }

    // MARK: - Single Day Cell
    private func dayCell(_ day: Int) -> some View {
        ZStack {

            Circle()
                .fill(backgroundColor(for: day))
                .frame(width: 42, height: 42)

            Text("\(day)")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(textColor(for: day))
                .zIndex(1)

            // ❄️ Freeze icon
            if freezeDays.contains(day) {
                Image(systemName: "snowflake")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
                    .offset(x: 12, y: -12)
            }

            // 🔥 Flame only for TODAY in CURRENT MONTH
            if isCurrentMonth && day == today {
                Image(systemName: "flame.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.orange)
                    .offset(y: -26)
                    .scaleEffect(flamePulse ? 1.15 : 0.9)
                    .opacity(0.9)
                    .onAppear {
                        withAnimation(
                            .easeInOut(duration: 1)
                                .repeatForever(autoreverses: true)
                        ) {
                            flamePulse.toggle()
                        }
                    }
            }
        }
    }

    // MARK: - Helpers
    private func backgroundColor(for day: Int) -> Color {
        if freezeDays.contains(day) {
            return Color.blue
        } else if activeDays.contains(day) {
            return Color.orange
        } else {
            return Color.clear
        }
    }

    private func textColor(for day: Int) -> Color {
        if freezeDays.contains(day) || activeDays.contains(day) {
            return .black
        } else {
            return Color.gray.opacity(0.8)
        }
    }

    private func changeMonth(_ value: Int) {
        currentDate = Calendar.current.date(
            byAdding: .month,
            value: value,
            to: currentDate
        ) ?? currentDate
    }
}
