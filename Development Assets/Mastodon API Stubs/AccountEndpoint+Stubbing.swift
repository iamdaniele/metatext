// Copyright © 2020 Metabolist. All rights reserved.

import Foundation

// swiftlint:disable line_length
let officialAccountJSON = #"""
{
    "id": "13179",
    "username": "Mastodon",
    "acct": "Mastodon",
    "display_name": "Mastodon",
    "locked": false,
    "bot": false,
    "discoverable": false,
    "group": false,
    "created_at": "2016-11-23T04:32:45.703Z",
    "note": "<p>Official account of the Mastodon project. News, releases, announcements. All in micro-blog form! Toot toot!</p>",
    "url": "https://mastodon.social/@Mastodon",
    "avatar": "https://files.mastodon.social/accounts/avatars/000/013/179/original/27bc451c7713091b.jpg",
    "avatar_static": "https://files.mastodon.social/accounts/avatars/000/013/179/original/27bc451c7713091b.jpg",
    "header": "https://files.mastodon.social/accounts/headers/000/013/179/original/4835294a8ed4c5a2.png",
    "header_static": "https://files.mastodon.social/accounts/headers/000/013/179/original/4835294a8ed4c5a2.png",
    "followers_count": 531199,
    "following_count": 10,
    "statuses_count": 166,
    "last_status_at": "2020-07-26",
    "emojis": [],
    "fields": [
        {
            "name": "Homepage",
            "value": "<a href=\"https://joinmastodon.org\" rel=\"me nofollow noopener noreferrer\" target=\"_blank\"><span class=\"invisible\">https://</span><span class=\"\">joinmastodon.org</span><span class=\"invisible\"></span></a>",
            "verified_at": "2018-10-31T04:11:00.076+00:00"
        },
        {
            "name": "Patreon",
            "value": "<a href=\"https://patreon.com/mastodon\" rel=\"me nofollow noopener noreferrer\" target=\"_blank\"><span class=\"invisible\">https://</span><span class=\"\">patreon.com/mastodon</span><span class=\"invisible\"></span></a>",
            "verified_at": null
        }
    ]
}
"""#

extension AccountEndpoint: Stubbing {
    func dataString(url: URL) -> String? {
        switch self {
        case .verifyCredentials: return officialAccountJSON
        }
    }
}
// swiftlint:enable line_length
