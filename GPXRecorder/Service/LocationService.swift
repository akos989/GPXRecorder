//
//  LocationService.swift
//  GPXRecorder
//
//  Created by Ákos Morvai on 2023. 04. 28..
//

import CoreLocation
import Foundation
import RxSwift

/// Service that receives location information using CoreLocation
class LocationService: NSObject, CLLocationManagerDelegate {
    /// The singletion shared instance of the class.
    static let shared = LocationService()
    
    /// Location manager object.
    var locationManager: CLLocationManager!
    
    /// The latest location that was received from the system.
    var lastLocation: CLLocation?
    
    /// RxSwift observable subject which publishes the a CLLocations object when the serivce receives a new location from CoreLocation.
    let currentLocationSubject = PublishSubject<CLLocation>()
    
    /// Initializer of the class. Creates the ``locationManager``, sets its delegate, sets the accuracy and requests privileges.
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestAlwaysAuthorization()
    }
    
    /// ``locationManager`` calls this method if the location privileges change.
    /// - Parameter manager: The CLLocationManager that registers the change in privileges.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            locationManager.requestLocation()
        }
    }
    
    /// ``locationManager`` calls this method if new location information is received.
    /// - Parameters:
    ///   - manager: The CLLocationManager that registers the location change.
    ///   - locations: The new location.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0] as CLLocation
        lastLocation = userLocation
        currentLocationSubject.onNext(userLocation)
    }
    
    /// ``locationManager`` calls this method if new heading information is received.
    /// - Parameters:
    ///   - manager: The CLLocationManager that registers the heading change.
    ///   - newHeading: The new heading.
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print("true heading: \(newHeading.trueHeading)")
        print("magnetic heading: \(newHeading.magneticHeading)")
        print("heading x: \(newHeading.x), y: \(newHeading.y), z: \(newHeading.z)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // TODO: complete error handling
        print("Location error: \(error.localizedDescription)")
    }
}
