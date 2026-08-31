//
//  SettingsView.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/31.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel = .init()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    appInfoView
                    userInfoView
                    appGeneralInfoView
                    signOutButton
                }
                .padding()
            }
            .onChange(of: viewModel.shouldDismiss) { _, _ in
                dismiss()
            }
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.appTheme.viewBackground)
            .toolbar { toolbarItems }
            .showError(item: $viewModel.error)
            .showAlert(item: $viewModel.alert)
        }
    }
}

private extension SettingsView {
    var appInfoView: some View {
        VStack(spacing: 16) {
            sectionHeader(title: viewModel.appName, sfSymbol: "info.circle")
            divider
            appDescriptionView
        }
        .padding()
        .background(Color.appTheme.cellBackground)
        .cornerRadius(.cell)
    }
    
    var userInfoView: some View {
        VStack(spacing: 16) {
            sectionHeader(title: "User Info", sfSymbol: "person.circle")
            divider
            ForEach(viewModel.userInfoData) { data in
                infoRow(title: data.name, value: data.info)
                if data != viewModel.userInfoData.last {
                    divider
                }
            }
        }
        .padding()
        .background(Color.appTheme.cellBackground)
        .cornerRadius(.cell)
    }
    
    var appGeneralInfoView: some View {
        VStack(spacing: 16) {
            sectionHeader(title: "App Info", sfSymbol: "person.circle")
            divider
            ForEach(viewModel.appInfoData) { data in
                infoRow(title: data.name, value: data.info)
                if data != viewModel.appInfoData.last {
                    divider
                }
            }
        }
        .padding()
        .background(Color.appTheme.cellBackground)
        .cornerRadius(.cell)
    }
    
    var appDescriptionView: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(.allDone)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .cornerRadius(.overall)
            Text(viewModel.appDescription)
                .font(.callout)
                .foregroundStyle(Color.appTheme.secondaryText)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    var signOutButton: some View {
        Text("Sign Out")
            .destructiveButton()
            .button(.press) {
                signOut()
            }
    }
    
    func sectionHeader(title: String, sfSymbol: String) -> some View {
        HStack {
            Text(title)
                .font(.title3)
                .fontWeight(.medium)
            Spacer()
            Image(systemName: sfSymbol)
        }
    }
    
    var divider: some View {
        Divider()
    }
    
    func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(Color.appTheme.secondaryText)
            Spacer(minLength: 8)
            Text(value)
                .fontWeight(.medium)
                .foregroundStyle(Color.appTheme.accent)
        }
        .frame(maxWidth: .infinity)
    }
    
    @ToolbarContentBuilder
    var toolbarItems: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            HStack(spacing: 5) {
                Image(systemName: "gear")
                    .foregroundStyle(Color.appTheme.text)
                Text("Settings")
            }
            .fontWeight(.semibold)
        }
        ToolbarItem(placement: .topBarTrailing) {
            Text("Done")
                .fontWeight(.semibold)
                .foregroundStyle(Color.appTheme.accent)
                .button {
                    dismiss()
                }
        }
    }
}

private extension SettingsView {
    func signOut() {
        viewModel.singOutAttempt()
    }
}

#Preview {
    SettingsView()
        .injectMockData()
}
