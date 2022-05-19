//
//  CommonViews.swift
//  UVIO
//
//  Created by Macostik on 17.05.2022.
//

import SwiftUI

struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Image.backButtonIcon
        }
    }
}

struct NextButton<V: View>: View {
    private var destination: V
    init(destination: V) {
        self.destination = destination
    }
    var body: some View {
        NavigationLink(destination: destination) {
            ZStack {
                HStack {
                    Image.nextIcon
                        .padding()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 48, alignment: .trailing)
            .background(Color.black)
            .cornerRadius(12)
            .padding(.horizontal)
            .overlay(textOverlay)
        }
    }
    var textOverlay: some View {
        Text(L10n.next)
            .font(.poppins(.medium, size: 14))
            .foregroundColor(.white)
    }
}

struct SkipButton: View {
    var body: some View {
        Button(action: {
            print("skip button click")
        }, label: {
            Text(L10n.skip)
                .font(.poppins(.medium, size: 14))
                .foregroundColor(Color.black)
        })
    }
}

func genderOverlay(type: String,
                   isSelected: Bool) -> some View {
    HStack {
        Circle()
            .foregroundColor(Color.grayscaleColor)
            .frame(width: 24, height: 24)
            .padding(.leading)
            .overlay(isSelected ?  Circle()
                .foregroundColor(Color.complementaryColor).frame(width: 12, height: 12).cornerRadius(6)
                .padding(.leading, 16) : nil)
        Text(type)
            .font(.poppins(.medium, size: 14))
        Spacer()
    }
}

struct ProgressView: View {
    var completed: Double = 1.0
    var body: some View {
        HStack(spacing: 18) {
            ZStack(alignment: .leading) {
                Capsule()
                    .frame(width: 160, height: 4)
                    .foregroundColor(Color.white)
                Capsule()
                    .frame(width: 160 * completed, height: 4)
                    .foregroundColor(Color.primaryGreenColor)
            }
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Color.primaryGreenColor)
                .frame(width: 12, height: 10)
        }
    }
}

struct LogoButton<Destination: View, Logo: View, Title: View>: View {
    private var destination: Destination
    private var logo: Logo
    private var  title: Title
    init(logo: Logo, title: Title, destination: Destination) {
        self.title = title
        self.logo = logo
        self.destination = destination
    }
    var body: some View {
        NavigationLink(destination: destination) {
            ZStack {
                HStack {
                    logo.padding()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 48, alignment: .leading)
            .background(Color.white.opacity(0.6))
            .cornerRadius(12)
            .padding(.horizontal)
            .overlay(textOverlay)
        }
    }
    var textOverlay: some View {
        title
            .font(.poppins(.medium, size: 14))
            .foregroundColor(.black)
    }
}

var privatePolicy: some View {
    Text(L10n.byContinuing)
        .font(.poppins(.regular, size: 12)) +
    Text(L10n.termsOfService)
        .font(.poppins(.bold, size: 12)) +
    Text("\n") +
    Text(L10n.and)
        .font(.poppins(.regular, size: 12)) +
    Text(L10n.privacyPolicy)
        .font(.poppins(.bold, fixedSize: 12))
}

var signUpBanner: some View {
    ZStack {
        Image.signUpLogo
            .frame(width: 96, height: 96)
            .background(Color.white)
            .cornerRadius(16)
    }
}

var signUpTitle: some View {
    VStack(spacing: 16) {
        Text(L10n.uvio)
            .font(.poppins(.bold, size: 21))
        Text(L10n.takeBackControl)
            .font(.poppins(.regular, size: 16))
            .padding(.horizontal, 40)
            .multilineTextAlignment(.center)
    }
    .padding(.bottom, 48)
}
