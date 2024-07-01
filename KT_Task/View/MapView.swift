//
//  MapView.swift
//  KT_Task
//
//  Created by Ganesh  on 6/28/24.
//

import SwiftUI
import GoogleMaps
import RealmSwift

struct GoogleMapsView: UIViewRepresentable {
    
    @State var mapView = GMSMapView()
    
    @Binding var Markerpoint : Location
    @Binding var coordinates : String
    @Binding var StartPoint : [CLLocationCoordinate2D]
    @Binding var IsanimateMap  : Bool
    
    @State var polyline = GMSPolyline()
    @State var animationPolyline = GMSPolyline()
    @State var path = GMSPath()
    @State var animationPath = GMSMutablePath()
    @State var i: UInt = 0
    @State var timer: Timer!
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        DispatchQueue.main.async {
            withAnimation(){
                if IsanimateMap {
                    MapPolyline()
                }else{
                    MapMarkerPoint()
                }
            }
        }
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.mapType =  GMSMapViewType.normal
        
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        DispatchQueue.main.async {
            withAnimation(){
                if IsanimateMap {
                    MapPolyline()
                }else{
                    MapMarkerPoint()
                }
            }
        }
    }
    
    func MapPolyline() {
        DispatchQueue.main.async {
            mapView.clear()
            
            path = GMSPath(fromEncodedPath: coordinates)!
            polyline = GMSPolyline(path: path)
            polyline.strokeColor = .gray
            polyline.strokeWidth = 3.0
            polyline.map = mapView
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.5)
            let bounds = GMSCoordinateBounds(path: path)
            mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
            CATransaction.commit()
            
            for (index,i) in StartPoint.enumerated() {
                if index == 0 {
                    let startingCoordinateMarker = GMSMarker()
                    startingCoordinateMarker.position = CLLocationCoordinate2D(latitude: i.latitude, longitude: i.longitude)
                    startingCoordinateMarker.icon = GMSMarker.markerImage(with: UIColor.green)
                    startingCoordinateMarker.map = mapView
                }
                
                if index == StartPoint.count - 1 {
                    let endCoordinateMarker = GMSMarker()
                    endCoordinateMarker.position = CLLocationCoordinate2D(latitude: i.latitude, longitude: i.longitude)
                    endCoordinateMarker.icon = GMSMarker.markerImage(with: UIColor.red)
                    endCoordinateMarker.map = mapView
                }
                
            }
            
            self.timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
                if IsanimateMap{
                    withAnimation(){
                        self.animatePolylinePath()
                    }
                }
            }
            
        }
    }
    
    func MapMarkerPoint() {
        DispatchQueue.main.async {
            mapView.clear()
            let camera = GMSCameraPosition.camera(withLatitude: Double(Markerpoint.latitude), longitude: Double(Markerpoint.longitude), zoom: 15)
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(Double(Markerpoint.latitude), Double(Markerpoint.longitude))
            marker.isDraggable = true
            marker.icon = GMSMarker.markerImage(with: UIColor.purple)
            marker.title = Markerpoint.Locationname
            marker.snippet = "\(Markerpoint.latitude) , \(Markerpoint.longitude)"
            mapView.selectedMarker = marker
            marker.map = mapView
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.5)
            mapView.animate(to:camera)
            CATransaction.commit()
        }
    }
    
    func animatePolylinePath() {
        DispatchQueue.main.async {
            if (self.i < self.path.count()) {
                self.animationPath.add(self.path.coordinate(at: self.i))
                self.animationPolyline.path = self.animationPath
                self.animationPolyline.strokeColor = UIColor.black
                self.animationPolyline.strokeWidth = 3
                self.animationPolyline.map = self.mapView
                self.i = i + 1
            }
            else {
                self.i = 0
                self.animationPath = GMSMutablePath()
                self.animationPolyline.map = nil
            }
        }
    }
}




