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

struct NextButton<Destination: View>: View {
    private var destination: Destination
    init(destination: Destination) {
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

struct SkipButton<Destination: View>: View {
    private var destination: Destination
    init(destination: Destination) {
        self.destination = destination
    }
    var body: some View {
        NavigationLink(destination: destination) {
            Text(L10n.skip)
                .font(.poppins(.medium, size: 14))
                .foregroundColor(Color.black)
        }
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
                    .foregroundColor(Color.grayBackgroundColor)
                Capsule()
                    .frame(width: 160 * completed, height: 4)
                    .foregroundColor(Color.black)
            }
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

var singUpLink: some View {
    Text(L10n.dontHaveAccount)
        .font(.poppins(.regular, size: 14)) +
    Text(L10n.signUp)
        .font(.poppins(.medium, size: 14))
        .foregroundColor(Color.complementaryColor)
}

var signUpBanner: some View {
    ZStack {
        Image.uvioIcon
            .frame(width: 96, height: 96)
            .background(Color.white)
            .cornerRadius(24)
    }
}

var signInBanner: some View {
    ZStack {
        Image.uvioIcon
            .frame(width: 96, height: 96)
            .background(Color.white)
            .cornerRadius(16)
    }
}

var signUpTitle: some View {
    VStack(spacing: 16) {
        Text(L10n.cone)
            .font(.poppins(.bold, size: 21))
        Text(L10n.awesome)
            .font(.poppins(.medium, size: 21))
            .padding(.horizontal)
            .padding(.top, 60)
            .multilineTextAlignment(.center)
    }
    .padding(.bottom, 48)
}

var signInTitle: some View {
    VStack(spacing: 16) {
        Text(L10n.cone)
            .font(.poppins(.bold, size: 21))
        Text(L10n.takeBackControl)
            .font(.poppins(.regular, size: 16))
            .padding(.horizontal, 40)
            .multilineTextAlignment(.center)
    }
    .padding(.bottom, 48)
}
