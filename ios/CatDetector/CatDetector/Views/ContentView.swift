//
//  ContentView.swift
//  CatDetector
//
//  Created by Fernando Zhu on 31/03/23.
//

import SwiftUI
import CoreData

struct ContentView: View {

    @EnvironmentObject var notifictionViewModel: NotificationViewModel
    var body: some View {
        NotificationList(records: notifictionViewModel.records)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        var imageUrl = ""
        var record = CatDetectionRecord(id: "0", date: "2023-04-01", time: "12:00:00", isRead: false, imageUrl: imageUrl)
        var records = [record]
        
        ContentView().environmentObject(NotificationViewModel())
    }
}
