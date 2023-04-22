//
//  NotificationDetail.swift
//  CatDetector
//
//  Created by Fernando Zhu on 21/04/23.
//

import SwiftUI

struct NotificationDetail: View {
    
    @EnvironmentObject var viewModel: NotificationViewModel
    var record: CatDetectionRecord
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: record.imageUrl)) { content in
                content.image?.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .infinity)
                    .clipped()
            }
            
            HStack {
                Text("ID:\t\t \(record.id)")
                Spacer()
            }
            HStack {
                Text("Date:\t \(record.date)")
                Spacer()
            }
            HStack {
                Text("Time:\t \(record.time)")
                Spacer()
            }
            
            Spacer()
            Button("Test") {
                viewModel.markRecordAsRead(id: record.id)
            }
        }
    }
}

struct NotificationDetail_Previews: PreviewProvider {
    static var previews: some View {
        
        var imageUrl = ""
        var record = CatDetectionRecord(id: "0", date: "2023-04-01", time: "12:00:00", isRead: false, imageUrl: imageUrl)
        
        NotificationDetail(record: record)
        Text("Disabled for now")
    }
}
