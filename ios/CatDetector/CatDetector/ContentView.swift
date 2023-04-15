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
        Text("Hello")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(NotificationViewModel())
    }
}
