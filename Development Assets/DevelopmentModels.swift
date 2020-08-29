// Copyright © 2020 Metabolist. All rights reserved.

import Foundation
import Combine

// swiftlint:disable force_try
private let decoder = MastodonDecoder()
private var cancellables = Set<AnyCancellable>()
private let devInstanceURL = URL(string: "https://mastodon.social")!
private let devIdentityID = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
private let devAccessToken = "DEVELOPMENT_ACCESS_TOKEN"

extension Account {
    static let development = try! decoder.decode(Account.self, from: Data(officialAccountJSON.utf8))
}

extension Instance {
    static let development = try! decoder.decode(Instance.self, from: Data(officialInstanceJSON.utf8))
}

extension IdentityDatabase {
    static func fresh() -> IdentityDatabase { try! IdentityDatabase(inMemory: true) }

    static var development: IdentityDatabase = {
        let db = IdentityDatabase.fresh()

        db.createIdentity(id: devIdentityID, url: devInstanceURL)
            .receive(on: ImmediateScheduler.shared)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &cancellables)

        db.updateAccount(.development, forIdentityID: devIdentityID)
            .receive(on: ImmediateScheduler.shared)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &cancellables)

        db.updateInstance(.development, forIdentityID: devIdentityID)
            .receive(on: ImmediateScheduler.shared)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &cancellables)

        return db
    }()
}

extension AppEnvironment {
    static let development = AppEnvironment(
        session: Session(configuration: .stubbing),
        webAuthSessionType: SuccessfulMockWebAuthSession.self,
        keychainServiceType: MockKeychainService.self,
        userDefaults: MockUserDefaults(),
        inMemoryContent: true)
}

extension AllIdentitiesService {
    static func fresh(
        identityDatabase: IdentityDatabase = .fresh(),
        keychainService: KeychainService = MockKeychainService(),
        environment: AppEnvironment = .development) -> AllIdentitiesService {
        AllIdentitiesService(
            identityDatabase: identityDatabase,
            environment: environment)
    }

    static let development = AllIdentitiesService(
        identityDatabase: .development,
        environment: .development)
}

extension IdentityService {
    static let development = try! AllIdentitiesService.development.identityService(id: devIdentityID)
}

extension UserNotificationService {
    static let development = UserNotificationService(userNotificationCenter: .current())
}

extension RootViewModel {
    static let development = RootViewModel(
        appDelegate: AppDelegate(),
        allIdentitiesService: .development,
        userNotificationService: .development)
}

extension AddIdentityViewModel {
    static let development = RootViewModel.development.addIdentityViewModel()
}

extension TabNavigationViewModel {
    static let development = RootViewModel.development.tabNavigationViewModel!
}

extension SecondaryNavigationViewModel {
    static let development = TabNavigationViewModel.development.secondaryNavigationViewModel()
}

extension IdentitiesViewModel {
    static let development = IdentitiesViewModel(identityService: .development)
}

extension ListsViewModel {
    static let development = ListsViewModel(identityService: .development)
}

extension PreferencesViewModel {
    static let development = PreferencesViewModel(identityService: .development)
}

extension PostingReadingPreferencesViewModel {
    static let development = PostingReadingPreferencesViewModel(identityService: .development)
}

extension NotificationTypesPreferencesViewModel {
    static let development = NotificationTypesPreferencesViewModel(identityService: .development)
}

extension FiltersViewModel {
    static let development = FiltersViewModel(identityService: .development)
}

extension EditFilterViewModel {
    static let development = EditFilterViewModel(filter: .new, identityService: .development)
}

extension StatusListViewModel {
    static let development = StatusListViewModel(
        statusListService: IdentityService.development.service(timeline: .home))
}

// swiftlint:enable force_try
