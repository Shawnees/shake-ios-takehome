//
//  Story.swift
//  takehome
//
//  Created by Adrien Carvalot on 03/11/2020.
//  Copyright © 2020 Takeoff Labs, Inc. All rights reserved.
//

import Foundation

struct Story: Decodable, Hashable {
    let imageURL: String?
    let videoURL: String?
    let uploadedAt: String
    let duration: Int
}
