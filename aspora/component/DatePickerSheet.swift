//
//  DatepickerSheet.swift
//  aspora
//
//  Created by Amritesh Kumar on 29/12/25.
//

import SwiftUI

struct DatePickerSheet: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var selected = Date()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                DatePicker(
                    "Choose APOD Date",
                    selection: $selected,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()

                if let error = viewModel.errorMessage {
                    Text(error).foregroundStyle(.red).font(.footnote)
                }

                Button("Fetch APOD") {
                    viewModel.fetchByDate(selected)
                    if viewModel.errorMessage != nil {
                        return
                    }
                    viewModel.showingDateDetail = true
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Select Date")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}
