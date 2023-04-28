//
//  RecorderService.swift
//  GPXRecorder
//
//  Created by Ákos Morvai on 2023. 04. 28..
//

import Foundation

struct GpxData: Codable {
    let lat: Double
    let long: Double
    let time: Date
}

class RecorderService {
    static let shared = RecorderService()
    
    init() {
        setupBindings()
    }

    func setupBindings() {
        LocationService.shared.currentLocationSubject
            .subscribe(<#T##observer: ObserverType##ObserverType#>)
    }
    
    func startRecording() {
        <#function body#>
    }
}
