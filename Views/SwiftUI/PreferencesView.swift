// Copyright © 2020 Metabolist. All rights reserved.

import Combine
import Mastodon
import SwiftUI
import ViewModels

struct PreferencesView: View {
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
            Section(header: Text("preferences.app")) {
                Group {
//                    if UIApplication.shared.supportsAlternateIcons {
//                        return NavigationLink(destination: AppIconPreferencesView(viewModel: viewModel)) {
//                            HStack {
//                                Text("preferences.app-icon")
//                                Spacer()
//                                if let appIcon = AppIcon.current {
//                                    if let image = appIcon.image {
//                                        image
//                                            .resizable()
//                                            .frame(
//                                                width: UIFont.preferredFont(forTextStyle: .body).lineHeight,
//                                                height: UIFont.preferredFont(forTextStyle: .body).lineHeight)
//                                            .cornerRadius(.defaultCornerRadius / 2)
//                                    }
//                                    Text(appIcon.nameLocalizedStringKey)
//                                        .foregroundColor(.secondary)
//                                }
//                            }
//                        }
//                    }
                    Picker("preferences.app.color-scheme", selection: $identityContext.appPreferences.colorScheme) {
                        ForEach(AppPreferences.ColorScheme.allCases) { option in
                            Text(option.localizedStringKey).tag(option)
                        }
                    }
                    NavigationLink("preferences.notifications",
                                   destination: NotificationPreferencesView(viewModel: viewModel))
                    Picker("preferences.status-word",
                           selection: $identityContext.appPreferences.statusWord) {
                        ForEach(AppPreferences.StatusWord.allCases) { option in
                            Text(option.localizedStringKey).tag(option)
                        }
                    }
//                    Toggle("preferences.edge-to-edge-view",
//                           isOn: $identityContext.appPreferences.edgeToEdgeView)
//                    Picker("preferences.display-favorites-as",
//                           selection: $identityContext.appPreferences.displayFavoritesAs) {
//                        ForEach(AppPreferences.DisplayFavoritesAs.allCases) { option in
//                            Text(option.localizedStringKey).tag(option)
//                        }
//                    }
//                    Toggle("preferences.show-reblog-and-favorite-counts",
//                           isOn: $identityContext.appPreferences.showReblogAndFavoriteCounts)
//                    Toggle("preferences.require-double-tap-to-reblog",
//                           isOn: $identityContext.appPreferences.requireDoubleTapToReblog)
//                    Toggle("preferences.require-double-tap-to-favorite",
//                           isOn: $identityContext.appPreferences.requireDoubleTapToFavorite)
                    Toggle("preferences.links.open-in-default-browser",
                           isOn: $identityContext.appPreferences.openLinksInDefaultBrowser)
                    if !identityContext.appPreferences.openLinksInDefaultBrowser {
                        Toggle("preferences.links.use-universal-links",
                               isOn: $identityContext.appPreferences.useUniversalLinks)
                    }
                    Toggle("preferences.show-labels-in-tab-bar",
                           isOn: $identityContext.appPreferences.showLabelsInTabBar)
                }
                Group {
                    Picker("preferences.media.autoplay.gifs",
                           selection: $identityContext.appPreferences.autoplayGIFs) {
                        ForEach(AppPreferences.Autoplay.allCases) { option in
                            Text(option.localizedStringKey).tag(option)
                        }
                    }
                    Picker("preferences.media.autoplay.videos",
                           selection: $identityContext.appPreferences.autoplayVideos) {
                        ForEach(AppPreferences.Autoplay.allCases) { option in
                            Text(option.localizedStringKey).tag(option)
                        }
                    }
                    Picker("preferences.media.avatars.animate",
                           selection: $identityContext.appPreferences.animateAvatars) {
                        ForEach(AppPreferences.AnimateAvatars.allCases) { option in
                            Text(option.localizedStringKey).tag(option)
                        }
                    }
                    Toggle("preferences.media.custom-emojis.animate",
                           isOn: $identityContext.appPreferences.animateCustomEmojis)
                    Toggle("preferences.media.headers.animate",
                           isOn: $identityContext.appPreferences.animateHeaders)
                }
                if viewModel.identityContext.identity.authenticated
                    && !viewModel.identityContext.identity.pending {
                    Picker("preferences.home-timeline-position-on-startup",
                           selection: $identityContext.appPreferences.homeTimelineBehavior) {
                        ForEach(AppPreferences.PositionBehavior.allCases) { option in
                            Text(option.localizedStringKey).tag(option)
                        }
                    }
                }
            }
        }
        .navigationTitle("account-settings")
        .alertItem($viewModel.alertItem)
        .onReceive(NotificationCenter.default.publisher(
                    for: UIAccessibility.videoAutoplayStatusDidChangeNotification)) { _ in
            viewModel.objectWillChange.send()
        }

    }
}

extension AppPreferences.ColorScheme {
    var localizedStringKey: LocalizedStringKey {
        switch self {
        case .system:
            return "preferences.app.color-scheme.system"
        case .light:
            return "preferences.app.color-scheme.light"
        case .dark:
            return "preferences.app.color-scheme.dark"
        }
    }
}

extension AppPreferences.StatusWord {
    var localizedStringKey: LocalizedStringKey {
        switch self {
        case .toot:
            return "toot"
        case .post:
            return "post"
        }
    }
}

extension AppPreferences.DisplayFavoritesAs {
    var localizedStringKey: LocalizedStringKey {
        switch self {
        case .favorites:
            return "favorites"
        case .likes:
            return "likes"
        }
    }
}

extension AppPreferences.AnimateAvatars {
    var localizedStringKey: LocalizedStringKey {
        switch self {
        case .everywhere:
            return "preferences.media.avatars.animate.everywhere"
        case .profiles:
            return "preferences.media.avatars.animate.profiles"
        case .never:
            return "preferences.media.avatars.animate.never"
        }
    }
}

extension AppPreferences.Autoplay {
    var localizedStringKey: LocalizedStringKey {
        switch self {
        case .always:
            return "preferences.media.autoplay.always"
        case .wifi:
            return "preferences.media.autoplay.wifi"
        case .never:
            return "preferences.media.autoplay.never"
        }
    }
}

extension AppPreferences.PositionBehavior {
    var localizedStringKey: LocalizedStringKey {
        switch self {
        case .localRememberPosition:
            return "preferences.position.remember-position"
        case .newest:
            return "preferences.position.newest"
        }
    }
}

#if DEBUG
import PreviewViewModels

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView(viewModel: .init(identityContext: .preview))
    }
}
#endif
