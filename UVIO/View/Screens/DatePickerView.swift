//
//  DatePickerView.swift
//  UVIO
//
//  Created by Macostik on 17.05.2022.
//

import SwiftUI

struct DatePickerView: View {
    
    @Binding var date: Date
    @Binding var isPresentedDatePicker: Bool

    var body: some View {
        VStack (alignment: .trailing) {
            Button(action: {
                withAnimation {
                    isPresentedDatePicker = false                    
                }
            }) {
                Text("DONE")
                    .font(.custom("Poppins-Regular", size: 16))
            }
            .padding()
            DatePicker("", selection: $date, displayedComponents: [.date])
                .datePickerStyle(.wheel)
        }
        .background(Color.white)
    }
}

struct DatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerView(date: .constant(Date()),
                       isPresentedDatePicker: .constant(false))
    }
}
