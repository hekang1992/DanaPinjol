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
    let latitude: Double
    let longitude: Double
    
    func toDictionary() -> [String: String] {
        return [
            "orexient": province,
            "writeer": countryCode,
            "allowability": country,
            "pleasture": street,
            "educationent": "\(latitude)",
            "mechano": "\(longitude)",
            "panern": city,
            "mega": district
        ]
    }
}

class LocationManager: NSObject {
    private let locationManager = CLLocationManager()
    private var completionHandler: ((Result<LocationInfo, Error>) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation(completion: @escaping (Result<LocationInfo, Error>) -> Void) {
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
        completionHandler = nil
    }
    
    private func reverseGeocode(location: CLLocation, completion: @escaping (Result<LocationInfo, Error>) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let placemark = placemarks?.first else {
                completion(.failure(LocationError.noPlacemarkFound))
                return
            }
            
            let locationInfo = LocationInfo(
                countryCode: placemark.isoCountryCode ?? "",
                country: placemark.country ?? "",
                province: placemark.administrativeArea ?? "",
                city: placemark.locality ?? "",
                district: placemark.subLocality ?? "",
                street: placemark.name ?? "",
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
            
            completion(.success(locationInfo))
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        stopLocationUpdate()
        
        reverseGeocode(location: location) { [weak self] result in
            self?.completionHandler?(result)
            self?.completionHandler = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        stopLocationUpdate()
        completionHandler?(.failure(error))
        completionHandler = nil
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdate()
        case .denied, .restricted:
            completionHandler?(.failure(LocationError.authorizationDenied))
            completionHandler = nil
        default:
            break
        }
    }
}

enum LocationError: Error {
    case authorizationDenied
    case noPlacemarkFound
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .authorizationDenied:
            return "Location authorization denied"
        case .noPlacemarkFound:
            return "No placemark found for the location"
        case .unknown:
            return "Unknown error occurred"
        }
    }
}