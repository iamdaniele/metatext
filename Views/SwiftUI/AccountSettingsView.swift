// Copyright © 2020 Metabolist. All rights reserved.

import Combine
import Mastodon
import SwiftUI
import ViewModels

struct AccountSettingsView: View {
    @StateObject var viewModel: PreferencesViewModel
    @StateObject var identityContext: IdentityContext
    @EnvironmentObject var rootViewModel: RootViewModel
    @Environment(\.accessibilityReduceMotion) var accessibilityReduceMotion

    init(viewModel: PreferencesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _identityContext = StateObject(wrappedValue: viewModel.identityContext)
    }

    var body: some View {
        Form {
            Section(header: Text(viewModel.identityContext.identity.handle)) {
                if viewModel.identityContext.identity.authenticated
                    && !viewModel.identityContext.identity.pending {
                    NavigationLink("preferences.filters",
                                   destination: FiltersView(
                                    viewModel: .init(identityContext: viewModel.identityContext)))
                    if viewModel.shouldShowNotificationTypePreferences {
                        NavigationLink("preferences.notification-types",
                                       destination: NotificationTypesPreferencesView(
                                        viewModel: .init(identityContext: viewModel.identityContext)))
                    }
                    Button("preferences.muted-users") {
                        rootViewModel.navigationViewModel?.navigateToMutedUsers()
                    }
                    .foregroundColor(.primary)
                    Button("preferences.blocked-users") {
                        rootViewModel.navigationViewModel?.navigateToBlockedUsers()
                    }
                    .foregroundColor(.primary)
                    NavigationLink("preferences.blocked-domains",
                                   destination: DomainBlocksView(viewModel: viewModel.domainBlocksViewModel()))
                    Toggle("preferences.use-preferences-from-server",
                           isOn: $viewModel.preferences.useServerPostingReadingPreferences)
                    Group {
                        Picker("preferences.posting-default-visiblility",
                               selection: $viewModel.preferences.postingDefaultVisibility) {
                            Text("status.visibility.public").tag(Status.Visibility.public)
                            Text("status.visibility.unlisted").tag(Status.Visibility.unlisted)
                            Text("status.visibility.private").tag(Status.Visibility.private)
                        }
                        Toggle("preferences.posting-default-sensitive",
                               isOn: $viewModel.preferences.postingDefaultSensitive)
                    }
                    .disabled(viewModel.preferences.useServerPostingReadingPreferences)
                }
                Group {
                    Picker("preferences.reading-expand-media",
                           selection: $viewModel.preferences.readingExpandMedia) {
                        Text("preferences.expand-media.default").tag(Preferences.ExpandMedia.default)
                        Text("preferences.expand-media.show-all").tag(Preferences.ExpandMedia.showAll)
                        Text("preferences.expand-media.hide-all").tag(Preferences.ExpandMedia.hideAll)
                    }
                    Toggle("preferences.reading-expand-spoilers",
                           isOn: $viewModel.preferences.readingExpandSpoilers)
                }
                .disabled(viewModel.preferences.useServerPostingReadingPreferences
                            && viewModel.identityContext.identity.authenticated)
            }

        }
        .navigationTitle("preferences")
        .alertItem($viewModel.alertItem)
        .onReceive(NotificationCenter.default.publisher(
                    for: UIAccessibility.videoAutoplayStatusDidChangeNotification)) { _ in
            viewModel.objectWillChange.send()
        }
    }
}

#if DEBUG
import PreviewViewModels

struct AccountSettings_Previews: PreviewProvider {
    static var previews: some View {
        AccountSettingsView(viewModel: .init(identityContext: .preview))
    }
}
#endif
