//
//  NotificationRow.swift
//  CatDetector
//
//  Created by Fernando Zhu on 21/04/23.
//
import SwiftUI

struct NotificationRow: View {
    var record: CatDetectionRecord
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: record.imageUrl)) { content in
                content.image?.resizable()
                    .aspectRatio(contentMode: .fill)
                    .background(Color.gray)
                    
            }.frame(width: 50, height: 50)
                .clipped()
            Text(record.date)
            Spacer()
            Circle().fill(Color.blue).frame(width: 10, height: 10)
                .opacity(record.isRead ? 0 : 1)
        }
    }
}

struct NotificationRow_Previews: PreviewProvider {
    static var previews: some View {
        var imageUrl = ""
        var record = CatDetectionRecord(id: "0", date: "2023-04-01", time: "12:00:00", isRead: false, imageUrl: imageUrl)
        NotificationRow(record: record)
    }
}
