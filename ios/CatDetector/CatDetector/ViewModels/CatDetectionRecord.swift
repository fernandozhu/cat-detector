//
//  CatDetectionRecord.swift
//  CatDetector
//
//  Created by Fernando Zhu on 21/04/23.
//

import Foundation
import SwiftUI


struct CatDetectionRecord: Identifiable, Codable {
    var id: String
    var date: String
    var time: String
    var isRead: Bool
    var imageUrl: String
}
