//
//  CommonViews.swift
//  UVIO
//
//  Created by Macostik on 17.05.2022.
//

import SwiftUI

struct backButton: View  {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Image("backButtonIcon")
        }
    }
}

struct nextButton<V: View>: View {
    
    private var destination: V
    
    init(destination: V) {
        self.destination = destination
    }
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Spacer()
                Text("Next")
                    .font(.custom("Poppins-Medium", size: 14))
                    .foregroundColor(Color.white)
                    .offset(x: 20)
                Spacer()
                Image("nextIcon")
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: 48, alignment: .trailing)
            .background(Color.black)
            .cornerRadius(12)
            .padding()
        }
    }
}

struct skipButton: View {
    
    var body: some View {
        Button(action: {
            print("skip button click")
        }, label: {
            Text("Skip")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(Color.black)
        })
    }
}

