//
//  NotificationList.swift
//  CatDetector
//
//  Created by Fernando Zhu on 21/04/23.
//

import SwiftUI

struct NotificationList: View {
    
    var records: [CatDetectionRecord]
    var body: some View {
        NavigationView {
            
            List(records, id: \.id) {record in
                NavigationLink {
                    NotificationDetail(record: record)
                } label: {
                    NotificationRow(record: record)
                }
            }.navigationTitle("🐱 Records")
        }

    }
}

struct NotificationList_Previews: PreviewProvider {
    static var previews: some View {
        
        var imageUrl = ""
        var record = CatDetectionRecord(id: "0", date: "2023-04-01", time: "12:00:00", isRead: false, imageUrl: imageUrl)
        var records = [record]
        NotificationList(records: records)
    }
}
