//
//  NotificationViewModel.swift
//  CatDetector
//
//  Created by Fernando Zhu on 2/04/23.
//

import Foundation

import WindowsAzureMessaging
import UIKit

//class NotificationViewModel: NSObject, ObservableObject, MSNotificationHubDelegate {
class NotificationViewModel: NSObject, ObservableObject {
    
    @Published var hasMoreResults: Bool = false
    @Published var records: [CatDetectionRecord] = []
    
    func fetchRecords() {
        records = []
        
        if let path = Bundle.main.path(forResource: "Settings", ofType: "plist") {
            if let propValues = NSDictionary(contentsOfFile: path) {
                let apiUrl = propValues["ApiUrl"] as? String ?? ""
                
                if let apiUrl = URL(string: apiUrl) {
                    var request = URLRequest(url: apiUrl)
                    request.httpMethod = "GET"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    let task = URLSession.shared.dataTask(with: request) {data, _, error in
                        guard let data = data, error == nil else {
                            return
                        }

                        do {
                            var response = try JSONDecoder().decode(ResponseModel.self, from: data)
                            // TODO: Publish values using the main thread
                            self.records = response.records
                        } catch {
                            print(error)
                        }
                    }
                    task.resume()
                }
            }
            
        }
    }
    
    func markRecordAsRead(id: String) {
        // TODO: Call API and mark the record as read
        print("*** IS READ ID: \(id)")
    }
}
