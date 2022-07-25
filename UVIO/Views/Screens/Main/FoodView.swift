//
//  FoodView.swift
//  UVIO
//
//  Created by Macostik on 17.06.2022.
//

import SwiftUI

struct FoodView: View {
    @ObservedObject var viewModel: MainViewModel
    @State var offset = 0.0
    var body: some View {
        ZStack {
            VStack {
                if viewModel.isFoodPresented {
                    contentView
                        .transition(.move(edge: .bottom))
                }
            }
        }
        .shadow(color: .gray.opacity(0.3), radius: 16, y: -10)
    }
}

struct FoodView_Previews: PreviewProvider {
    static var previews: some View {
        FoodView(viewModel: MainViewModel())
    }
}

extension FoodView {
    var contentView: some View {
        VStack {
            VStack {
                Capsule()
                    .foregroundColor(Color.grayScaleColor)
                    .frame(width: 56, height: 4)
                    .padding(.top)
                Image.foodIcon
                    .padding(.top, 5)
                Text(L10n.whatEat)
                    .font(.poppins(.medium, size: 18))
                    .padding(.top, -10)
                whenContainer
                timeContainer
                foodContainer
                carbsContainer
                addNote
                submitLogButton
                cancelButton
                    .padding(.bottom, 40)
            }
            .background(Color.bottomBGColor)
            .clipShape(RoundedCorner(radius: 24,
                                     corners: [.topLeft, .topRight]))
            .offset(y: self.offset)
            .gesture(DragGesture()
                .onChanged { gesture in
                    let yOffset = gesture.location.y
                    if yOffset > 0 &&
                        !viewModel.isFoodCalendarOpen &&
                        !viewModel.isTimePickerOpen &&
                        !viewModel.isCarbsAdded {
                        offset = yOffset
                    }
                }
                .onEnded { _ in
                    withAnimation {
                        self.viewModel.isFoodPresented = !(offset > 200)
                        self.offset = 0
                    }
                }
            )
        }.background(Color.clear)
    }
    var whenContainer: some View {
        VStack {
            Button {
                viewModel.isTimePickerOpen = false
                viewModel.isFoodCalendarOpen.toggle()
            } label: {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color.white)
                    .overlay(whenOverlay, alignment: .leading)
                    .frame(height: 48)
                    .padding(.horizontal)
            }
        }
    }
    var whenOverlay: some View {
        HStack {
            Text(L10n.when)
                .font(.poppins(.medium, size: 14))
            Text(viewModel.selectedFoodDate)
                .font(.poppins(.bold, size: 14))
        }
        .foregroundColor(Color.black)
        .padding()
    }
    var timeContainer: some View {
        VStack {
            if viewModel.isCalendarOpen {
                VStack(alignment: .trailing) {
                    DatePicker("",
                               selection: $viewModel.foodWhenValue,
                               displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .onChange(of: viewModel.foodWhenValue) { _ in
                            withAnimation {
                                viewModel.isCalendarOpen = false
                            }
                        }
                }
                .background(Color.white)
                .cornerRadius(16)
                .padding(.horizontal)
                .animation(.easeInOut)
            } else {
                Button {
                    viewModel.isTimePickerOpen.toggle()
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color.white)
                        .overlay(timeOverlay, alignment: .leading)
                        .frame(height: 48)
                        .padding(.horizontal)
                }
            }
        }
    }
    var timeOverlay: some View {
        HStack {
            Text(L10n.time)
                .font(.poppins(.medium, size: 14))
            Text(viewModel.selectedFoodTime)
                .font(.poppins(.bold, size: 14))
        }
        .foregroundColor(Color.black)
        .padding()
    }
    var foodContainer: some View {
        VStack(alignment: .trailing) {
            if viewModel.isTimePickerOpen {
                DatePicker("", selection: $viewModel.foodTimeValue, displayedComponents: [.hourAndMinute])
                    .datePickerStyle(.wheel)
                    .background(Color.white)
                    .cornerRadius(16)
                    .padding(.horizontal)
                    .animation(.easeInOut)
            } else if viewModel.isCarbsAdded {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color.white)
                    .overlay(
                        Picker("", selection: $viewModel.foodCarbs) {
                            ForEach(CarbsPickerData.allCases, id: \.self) {
                                Text($0.description)
                            }
                        }
                        .pickerStyle(.wheel)
                    )
                    .frame(height: 156)
                .padding(.horizontal)
            } else {
                VStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color.white)
                        .overlay(foodOverlay, alignment: .leading)
                        .frame(height: 48)
                        .padding(.horizontal)
                }
            }
        }
    }
    var foodOverlay: some View {
        HStack {
            Text(L10n.foodEaten)
                .font(.poppins(.medium, size: 14))
            TextField("", text: $viewModel.foodName)
                .font(.poppins(.bold, size: 14))
                .accentColor(Color.black)
                .multilineTextAlignment(.leading)
        }
        .foregroundColor(Color.black)
        .padding()
    }
    var carbsContainer: some View {
        Button {
            viewModel.isCarbsAdded.toggle()
        } label: {
            VStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color.white)
                    .overlay(carbsOverlay, alignment: .leading)
                    .frame(height: 48)
                    .padding(.horizontal)
            }
        }
    }
    var carbsOverlay: some View {
        HStack {
            Text(L10n.carbs)
                .font(.poppins(.medium, size: 14))
            Text(viewModel.foodCarbs.description)
                .font(.poppins(.bold, size: 14))
        }
        .foregroundColor(Color.black)
        .padding()
    }
    var addNote: some View {
        VStack {
            if viewModel.isNodeAdded {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color.white)
                    .overlay(inputNoteOverlay, alignment: .leading)
                    .frame(height: 48)
                    .padding(.horizontal)
            } else {
                Button {
                    viewModel.isNodeAdded = true
                    viewModel.isCalendarOpen = false
                    viewModel.isTimePickerOpen = false
                    viewModel.isCarbsAdded = false
                } label: {
                    Text(L10n.addNote)
                        .font(.poppins(.medium, size: 14))
                        .foregroundColor(Color.complementaryColor)
                        .padding(.top)
                }
            }
        }
    }
    var inputNoteOverlay: some View {
        HStack {
            Text(L10n.myNote)
                .font(.poppins(.medium, size: 14))
            TextField("", text: $viewModel.foodNote)
                .font(.poppins(.bold, size: 14))
                .accentColor(Color.black)
                .multilineTextAlignment(.leading)
        }
        .foregroundColor(Color.black)
        .padding(.horizontal)
    }
    var submitLogButton: some View {
        Button {
            withAnimation {
                    viewModel.isFoodPresented = false
            }
            viewModel.subminFoodPublisher.send()
        } label: {
            ZStack {
                HStack {
                    Image.checkMarkIcon
                        .padding()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 48, alignment: .trailing)
            .background(Color.complementaryColor)
            .cornerRadius(12)
            .padding(.horizontal)
            .overlay(
                Text(L10n.submitFood)
                    .font(.poppins(.medium, size: 14))
                    .foregroundColor(Color.white)
            )
        }
        .padding(.top, 17)
    }
    var cancelButton: some View {
        Button {
            withAnimation {
                viewModel.isFoodPresented = false
            }
        } label: {
            Text(L10n.cancel)
                .font(.poppins(.medium, size: 14))
                .foregroundColor(Color.black)
                .frame(height: 48)
                .padding(.horizontal)
        }
    }
}
