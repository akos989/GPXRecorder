//
//  RecorderService.swift
//  GPXRecorder
//
//  Created by Ákos Morvai on 2023. 04. 28..
//

import CoreLocation
import Foundation
import RxCocoa
import RxSwift

struct GpxData: Codable {
    var wpt: [GpxCoordinate]
}

struct GpxCoordinate: Codable {
    let lat: Double
    let long: Double
    let time: Date
}

class RecorderService {
    static let shared = RecorderService()
    
    let disposeBag = DisposeBag()
    
    var newGpxData: GpxData?
    
    var gpxDataArray = [GpxData]()
    
    let recordedCoordinatesNumberSubject = PublishSubject<Int>()
    let gpxDataArrayChangedSubject = PublishSubject<[GpxData]>()
    
    init() {
        setupBindings()
        loadData()
    }
    
    func setupBindings() {
        LocationService.shared.currentLocationSubject
            .subscribe(onNext: { [weak self] newLocation in
                if self?.newGpxData != nil {
                    if let lastWptTime = self?.newGpxData?.wpt.last?.time,
                       let seconds = Calendar.current.dateComponents([.second], from: lastWptTime, to: Date()).second,
                       seconds < 1  { return }
                    
                    self?.newGpxData?.wpt.append(GpxCoordinate(lat: newLocation.coordinate.latitude, long: newLocation.coordinate.longitude, time: newLocation.timestamp))
                    self?.recordedCoordinatesNumberSubject.onNext(self?.newGpxData?.wpt.count ?? 0)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func loadData() {
        let url = getDocumentsDirectory().appendingPathComponent("gpxdata.json")
        
        if let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode([GpxData].self, from: data) {
            gpxDataArray = decoded
            gpxDataArrayChangedSubject.onNext(gpxDataArray)
        }
    }
    
    func saveData() {
        let url = getDocumentsDirectory().appendingPathComponent("gpxdata.json")
        
        if let encoded = try? JSONEncoder().encode(gpxDataArray) {
            do {
                try encoded.write(to: url, options: .completeFileProtection)
            } catch {
                print("error")
            }
        }
    }
    
    func startRecording() {
        newGpxData = GpxData(wpt: [])
    }
    
    func stopRecording() {
        guard let newGpxData = newGpxData else { return }
        
        gpxDataArray.append(newGpxData)
        gpxDataArrayChangedSubject.onNext(gpxDataArray)
        saveData()
        self.newGpxData = nil
    }
    
    private func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // just send back the first one, which ought to be the only one
        return paths[0]
    }
}
