//
//  EntryView.swift
//  UVIO
//
//  Created by Macostik on 24.06.2022.
//

import SwiftUI

struct EntryView: View {
    var listViewEntry: ListViewEntry
    var body: some View {
        contentView
    }
}

struct EntryView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView(listViewEntry: ListViewEntry(
            image: Image.foodIcon,
            title: Text("Food log"),
            subTitle: Text("Pizza Margherita"),
            action: Text("Carbs - 40g"),
            note: Text("Insulin log"),
            timer: Text("10:15 am")
        ))
    }
}
extension EntryView {
    var contentView: some View {
            HStack(spacing: 12) {
                image
                ZStack(alignment: .leading) {
                    HStack(spacing: 12) {
                        listViewEntry.title
                            .offset(y: -10)
                        listViewEntry.action
                            .padding(3)
                            .background(
                                listViewEntry.mainColor.cornerRadius(8)
                            )
                            .offset(y: -10)
                    }
                    listViewEntry.subTitle
                        .offset(y: 10)
                }
                Spacer()
                listViewEntry.timer
                    .font(.poppins(.medium, size: 10))
                Image.vDotsIcon
            }
            .padding()
            .background(Color.white.cornerRadius(12))
            .padding(.horizontal)
    }
    var image: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(width: 32, height: 32)
                .foregroundColor(
                    listViewEntry.mainColor
                )
            listViewEntry.image
                .resizable()
                .frame(width: 17, height: 17)
        }
    }
}
