// Copyright © 2020 Metabolist. All rights reserved.

import Kingfisher
import SwiftUI
import ViewModels

struct IdentitiesView: View {
    @StateObject var viewModel: IdentitiesViewModel
    @EnvironmentObject var rootViewModel: RootViewModel
    @Environment(\.displayScale) var displayScale: CGFloat

    var body: some View {
        Form {
            Section {
                NavigationLink(
                    destination: AddIdentityView(viewModel: rootViewModel.addIdentityViewModel()),
                    label: {
                        Label("add", systemImage: "plus.circle")
                    })
            }
            section(title: "identities.accounts", identities: viewModel.authenticated)
            section(title: "identities.browsing", identities: viewModel.unauthenticated)
            section(title: "identities.pending", identities: viewModel.pending)
        }
        .toolbar {
            ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                EditButton()
            }
        }
    }
}

private extension IdentitiesView {
    @ViewBuilder
    func section(title: LocalizedStringKey, identities: [Identity]) -> some View {
        if identities.isEmpty {
            EmptyView()
        } else {
            Section(header: Text(title)) {
                List {
                    ForEach(identities) { identity in
                        Button {
                            withAnimation {
                                rootViewModel.identitySelected(id: identity.id)
                            }
                        } label: {
                            row(identity: identity)
                        }
                        .disabled(identity.id == viewModel.currentIdentityId)
                        .buttonStyle(PlainButtonStyle())
                    }
                    .onDelete {
                        guard let index = $0.first else { return }

                        rootViewModel.deleteIdentity(id: identities[index].id)
                    }
                }
            }
        }
    }

    @ViewBuilder
    func row(identity: Identity) -> some View {
        HStack {
            KFImage(identity.image)
                .downsampled(dimension: 40, scaleFactor: displayScale)
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                if identity.authenticated {
                    if let account = identity.account {
                        CustomEmojiText(
                            text: account.displayName,
                            emojis: account.emojis,
                            textStyle: .headline)
                    }
                    Text(identity.handle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } else {
                    if let instance = identity.instance {
                        CustomEmojiText(
                            text: instance.title,
                            emojis: [],
                            textStyle: .headline)
                        Text(instance.uri)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } else {
                        Text(identity.handle)
                            .font(.headline)
                    }
                }
                Spacer()
            }
            Spacer()
            if identity.id == viewModel.currentIdentityId {
                Image(systemName: "checkmark.circle")
            }
        }
    }
}

#if DEBUG
import PreviewViewModels

struct IdentitiesView_Previews: PreviewProvider {
    static var previews: some View {
        IdentitiesView(viewModel: .init(identification: .preview))
            .environmentObject(RootViewModel.preview)
    }
}
#endif
