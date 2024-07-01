//
//  LocationManager.swift
//  KT_Task
//
//  Created by Ganesh  on 6/28/24.
//

import Foundation
import CoreLocation
import RealmSwift

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var locationManager = CLLocationManager()
    private var timer: Timer?
    @Published var locations : [Location] = []
    @Published var SessionManagerobj = SessionManager()
    @Published var coordinate2D = [CLLocationCoordinate2D]()
    @Published var coordinates = String()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        // MARK: - 15 min once it will get location -
        
        timer = Timer.scheduledTimer(withTimeInterval: 900, repeats: true) { _ in
            DispatchQueue.main.async {
                self.fetchCurrentLocation()
            }
        }
    }
    
    // Get Location func
    func fetchCurrentLocation() {
        if let location = locationManager.location {
            reverseGeocode(location:location)
        }
    }
    
}



extension LocationManager {
    
    // Get area name func
    func reverseGeocode(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            var Name : String = ""
            
            if error != nil {
                Name = "Unknown"
            }
            
            if let placemark = placemarks?.first {
                if let city = placemark.name {
                    Name = city
                } else {
                    Name = "Unknown"
                }
            }else{
                Name = "Unknown"
            }
            
            
            let newLocation = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, Locationname: Name, timestamp: Date())
            
            self.saveLocationToRealm(location: newLocation)
        }
    }
    
    // Save location
    func saveLocationToRealm(location: Location) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(location)
        }
        NotificationCenter.default.post(name: Notification.Name.init(rawValue: "Location"), object: nil, userInfo:nil)
        
    }
    
    // Fetch location
    func fetchLocations() {
        let realm = try! Realm()
        let results = realm.objects(Location.self)
        locations = Array(results)
    }
    
    func fetchData() -> [Location] {
        let realm = try! Realm()
        let results = realm.objects(Location.self)
        return Array(results)
    }
    
    
    func FetchPolyline() {
        
        DispatchQueue.main.async {
            let realm = try! Realm()
            let results = realm.objects(Location.self)
            
            for i in Array(results).filter({$0.Userid == UserDefaults.standard.string(forKey: "isLogged") ?? "1"}) {
                self.coordinate2D.append(CLLocationCoordinate2D(latitude: i.latitude, longitude: i.longitude))
            }
            
            
            if let firstCoordinate = self.coordinate2D.first, let lastCoordinate = self.coordinate2D.last {
                self.SessionManagerobj.requestDirections(from:firstCoordinate, to: lastCoordinate, completionHandler: {
                    result , err in
                    if err == nil {
                        self.coordinates = ""
                        if let coordinate = result {
                            self.coordinates = coordinate
                        }
                    }else{
                        print(err?.localizedDescription as Any)
                    }
                    
                })
            } else {
                print("The array is empty.")
            }
            
        }
    }
    
    
    class SessionManager {
        
        func requestDirections(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D, completionHandler: @escaping (String?, Error?) -> Void) {
            guard let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(start.latitude),\(start.longitude)&destination=\(end.latitude),\(end.longitude)&key=\(Constant.APIkEY)") else {
                let error = NSError(domain: "LocalDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create object URL"])
                print("Error: \(error)")
                completionHandler(nil, error)
                return
            }
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    print("Error: \(error!)")
                    completionHandler(nil, error)
                    return
                }
                
                do {
                    
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                          let routes = json["routes"] as? [[String: Any]] else {
                        let error = NSError(domain: "GoogleDirectionsRequest", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON response"])
                        completionHandler(nil, error)
                        return
                    }
                    
                    for route in routes {
                        DispatchQueue.main.async {
                            if let routeOverviewPolyline = route["overview_polyline"] as? [String: Any],
                               let points = routeOverviewPolyline["points"] as? String {
                                completionHandler(points, nil)
                            }
                        }
                    }
                    
                    
                    
                } catch let error {
                    print("Error: \(error)")
                    completionHandler(nil, error)
                }
            }.resume()
        }
    }
}

