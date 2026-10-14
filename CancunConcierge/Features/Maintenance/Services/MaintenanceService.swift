//
//  MaintenanceService.swift
//  CancunConcierge
//
//  Created by usuario on 14/10/26.
//

import Foundation

final class MaintenanceService {
    
    func submitRequest(_ request: MaintenanceRequest, completion: @escaping (Bool)-> Void) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("Request Received \(request.title)")
            completion(true)
        }
    }
}
