//
//  Settings.swift
//  Investiro
//
//  Created by Adrian Neshad on 2025-11-02.
//

import SwiftUI
import StoreKit
import MessageUI
import AlertToast

struct SettingsView: View {
    @AppStorage("darkMode") private var darkMode = true
    @AppStorage("appLanguage") private var appLanguage = "en"
    @AppStorage("adsRemoved") private var adsRemoved = false
    @State private var showShareSheet = false
    @State private var showRestoreAlert = false
    @State private var showPurchaseSheet = false
    @State private var restoreStatus: RestoreStatus?
    @State private var showMailFeedback = false
    @State private var mailErrorAlert = false
    @State private var showClearAlert = false
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var showAppIconSelector = false
    @State private var showNotificationSheet = false
    @State private var showNotificationAlert = false
    @State private var showCountryAlert = false

    enum RestoreStatus {
        case success, failure
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text(StringManager.shared.get("general"))) {
                    Picker(StringManager.shared.get("language"), selection: $appLanguage) {
                        Text("🇺🇸 English").tag("en")
                        Text("🇸🇪 Svenska").tag("sv")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Toggle(isOn: $darkMode) {
                        Label {
                            Text(StringManager.shared.get("darkmode"))
                        } icon: {
                            Image(systemName: "moon")
                        }
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .blue))

                    Button(action: {
                        showAppIconSelector = true
                    }) {
                        HStack {
                            Label {
                                Text(StringManager.shared.get("väljappikon"))
                                    .foregroundColor(.blue)
                            } icon: {
                                Image(systemName: "app.dashed")
                                    .foregroundColor(.blue)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            }
                    }
                    .alert(isPresented: $showCountryAlert) {
                        Alert(
                            title: Text(StringManager.shared.get("bytland")),
                            message: Text(""),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
                Section(header: Text(StringManager.shared.get("om"))) {
                    Button(action: {
                        requestReview()
                    }) {
                        Label(StringManager.shared.get("betygsätt"), systemImage: "star")
                    }
                    Button(action: {
                        showShareSheet = true
                    }) {
                        Label(StringManager.shared.get("delaappen"), systemImage: "square.and.arrow.up")
                    }
                    .sheet(isPresented: $showShareSheet) {
                        let message = StringManager.shared.get("kollain")
                        let appLink = URL(string: "https://apps.apple.com/us/app/unifeed/id6746576849")!
                        ShareSheet(activityItems: [message, appLink])
                            .presentationDetents([.medium])
                    }
                    Button(action: {
                        if MFMailComposeViewController.canSendMail() {
                            showMailFeedback = true
                        } else {
                            mailErrorAlert = true
                        }
                    }) {
                        Label(StringManager.shared.get("gefeedback"), systemImage: "envelope")
                    }
                    .sheet(isPresented: $showMailFeedback) {
                        MailFeedback(isShowing: $showMailFeedback,
                                     recipientEmail: "Adrian.neshad1@gmail.com",
                                     subject: StringManager.shared.get("unifeedfeedback"),
                                     messageBody: "")
                    }
                }
                
                Section(header: Text(StringManager.shared.get("andraappar"))) {
                    Link(destination: URL(string: "https://apps.apple.com/us/app/univert/id6745692591")!) {
                        HStack {
                            Image("univert")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .cornerRadius(8)
                            Text("Univert - Unit Converter")
                        }
                    }
                    Link(destination: URL(string: "https://apps.apple.com/us/app/flixswipe-explore-new-movies/id6746716902")!) {
                        HStack {
                            Image("flixswipe")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .cornerRadius(8)
                            Text("SwipeFlix - Explore New Movies")
                        }
                    }
                }
                Section {
                    Text(appVersion)
                }
                
                Section {
                    EmptyView()
                } footer: {
                    VStack(spacing: 4) {
                        AppVersion()
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, -100)
                }
            }
            .navigationTitle(StringManager.shared.get("settings"))
            .toast(isPresenting: $showToast) {
                AlertToast(type: .complete(Color.green), title: toastMessage)
            }
        }
    }
    
    @Environment(\.requestReview) var requestReview

    private var appVersion: String {
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"
            let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "?"
            return "Version \(version) (\(build))"
        }
}
