//
//  DataModel.swift
//  aspora
//
//  Created by Amritesh Kumar on 29/12/25.
//

import Foundation

struct APODResponse: Codable {
    
    var copyright: String?
    var date: String
    var explanation: String
    var hdurl: String?
    var media_type: String
    var service_version: String
    var title: String
    var url: String
}
