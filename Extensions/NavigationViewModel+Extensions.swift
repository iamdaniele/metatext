// Copyright © 2021 Metabolist. All rights reserved.

import Foundation
import UIKit
import ViewModels

extension NavigationViewModel.Tab {
    var title: String {
        switch self {
        case .timelines:
            return NSLocalizedString("main-navigation.timelines", comment: "")
        case .notifications:
            return NSLocalizedString("main-navigation.notifications", comment: "")
        case .messages:
            return NSLocalizedString("main-navigation.conversations", comment: "")
        case .profile:
            return NSLocalizedString("main-navigation.profile", comment: "")
        case .bookmarks:
            return NSLocalizedString("main-navigation.bookmarks", comment: "")
        }
    }

    var imageName: UIImage {
        switch self {
        case .timelines:
            return UIImage(systemName: "newspaper")!
        case .notifications:
            return UIImage(systemName: "bell")!
        case .messages:
            return UIImage(systemName: "envelope")!
        case .profile:
            return UIImage(systemName: "person")!
        case .bookmarks:
            return UIImage(systemName: "bookmark")!
        }
    }

    var tabBarItem: UITabBarItem {
        UITabBarItem(title: nil, image: imageName, selectedImage: nil)
    }
}
