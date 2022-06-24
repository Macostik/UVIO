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
            type: Text("Food log"),
            value: Text("Pizza Margherita"),
            action: Text("Carbs - 40g"),
            note: Text("Insulin log"),
            timer: Text("10:15 am")
        ))
    }
}
extension EntryView {
    var contentView: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color.white)
                contentViewOverlay
            }
            .padding(.horizontal)
            .aspectRatio(contentMode: .fit)
    }
    var contentViewOverlay: some View {
        VStack {
            HStack(spacing: 12) {
                listViewEntry.image
                    .resizable()
                    .frame(width: 17, height: 17)
                    .background(
                        Color.primaryGreenColor.cornerRadius(8)
                    .frame(width: 32, height: 32)
                    )
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        listViewEntry.type
                            .font(.poppins(.bold, size: 12))
                        listViewEntry.action
                            .font(.poppins(.medium, size: 10))
                            .padding(3)
                            .background(
                                Color.capsulaGrayColor.cornerRadius(8)
                            )
                    }
                    listViewEntry.value
                        .font(.poppins(.medium, size: 12))
                }
                Spacer()
                listViewEntry.timer
                    .font(.poppins(.medium, size: 10))
                Image.vDotsIcon
            }
        }
        .padding(.horizontal)
    }
}
