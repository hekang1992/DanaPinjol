//
//  LocationInfo.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/21.
//

import Foundation
import CoreLocation

struct LocationInfo {
    let countryCode: String
    let country: String
    let province: String
    let city: String
    let district: String
    let street: String
    let latitude: String
    let longitude: String
    
    func toDictionary() -> [String: String] {
        return [
            "orexient": province,
            "writeer": countryCode,
            "allowability": country,
            "pleasture": street,
            "educationent": latitude,
            "mechano": longitude,
            "panern": city,
            "mega": district
        ]
    }
}

enum LocationError: Error {
    case authorizationDenied
    case noPlacemarkFound
    case unknown
}

class LocationManager: NSObject {
    
    private let locationManager = CLLocationManager()
    private var completionHandler: ((Result<LocationInfo, Error>) -> Void)?
    
    private var hasCompleted = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation(completion: @escaping (Result<LocationInfo, Error>) -> Void) {
        hasCompleted = false
        completionHandler = completion
        
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdate()
            
        case .denied, .restricted:
            completion(.failure(LocationError.authorizationDenied))
            
        @unknown default:
            completion(.failure(LocationError.unknown))
        }
    }
    
    private func startLocationUpdate() {
        locationManager.startUpdatingLocation()
    }
    
    private func stopLocationUpdate() {
        locationManager.stopUpdatingLocation()
    }
    
    private func reverseGeocode(location: CLLocation,
                                completion: @escaping (Result<LocationInfo, Error>) -> Void) {
        let geocoder = CLGeocoder()
        
        let latitude = String(format: "%.10f", location.coordinate.latitude)
        let longitude = String(format: "%.10f", location.coordinate.longitude)
        
        UserDefaults.standard.set(latitude, forKey: "dp_latitude")
        UserDefaults.standard.set(longitude, forKey: "dp_longitude")
        UserDefaults.standard.synchronize()
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let placemark = placemarks?.first else {
                completion(.failure(LocationError.noPlacemarkFound))
                return
            }
            
            let info = LocationInfo(
                countryCode: placemark.isoCountryCode ?? "",
                country: placemark.country ?? "",
                province: placemark.administrativeArea ?? "",
                city: placemark.locality ?? "",
                district: placemark.subLocality ?? "",
                street: placemark.name ?? "",
                latitude: String(format: "%.10f", location.coordinate.latitude),
                longitude: String(format: "%.10f", location.coordinate.longitude)
            )
            
            completion(.success(info))
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdate()
            
        case .denied, .restricted:
            guard !hasCompleted else { return }
            hasCompleted = true
            completionHandler?(.failure(LocationError.authorizationDenied))
            
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        
        guard !hasCompleted, let location = locations.last else { return }
        
        hasCompleted = true
        
        stopLocationUpdate()
        
        reverseGeocode(location: location) { [weak self] result in
            self?.completionHandler?(result)
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        
        guard !hasCompleted else { return }
        
        hasCompleted = true
        stopLocationUpdate()
        
        completionHandler?(.failure(error))
    }
}
