//
//  ResponseModel.swift
//  CatDetector
//
//  Created by Fernando Zhu on 22/04/23.
//

import Foundation

struct ResponseModel: Codable {
    var hasMoreResults: Bool
    var records: [CatDetectionRecord]
}
