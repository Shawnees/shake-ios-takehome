//
//  InstaViewModel.swift
//  InstaLike
//
//  Created by Dylan Oudin on 03/04/2024.
//

import Foundation

class InstaViewModel {

    let users: [User]

    @Published var userIndex = 0
    @Published var currentStory: String?
    @Published var indexStory = 0
    @Published var currentMediaUrl = ""

    var currentUser: User?

    init(users: [User]) {
        self.users = users
    }

    func nextStory() {
        guard let user = currentUser, indexStory + 1 < user.stories.count else { return }

        indexStory += 1
        currentStory = user.stories[indexStory].imageURL
    }

    func previousStory() {
        guard let user = currentUser, indexStory - 1 >= 0 else { return }

        indexStory -= 1
        currentStory = user.stories[indexStory].imageURL
    }

    func nextIndex() {
        guard userIndex + 1 < users.count else { return }
        userIndex += 1
        currentUser = users[userIndex]
        currentStory = currentUser?.stories.first(where: { $0.imageURL != nil})?.imageURL
//        currentStory = currentUser?.stories[0].imageURL
    }

    func previousIndex() {
        guard userIndex - 1 >= 0 else { return }
        userIndex -= 1
        currentUser = users[userIndex]
        currentStory = currentUser?.stories.first(where: { $0.imageURL != nil})?.imageURL
//       currentStory = currentUser?.stories[0].imageURL
    }
}
