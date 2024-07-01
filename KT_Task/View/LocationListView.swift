//
//  LocationListView.swift
//  KT_Task
//
//  Created by Ganesh  on 6/28/24.
//

import SwiftUI
import RealmSwift
import GoogleMaps

struct LocationListView: View {
    
    @ObservedObject var locationManagervm = LocationManager()
    
    @State private var ShowSwitchUserView : Bool = false
    @State private var ShowMapView : Bool = false
    
    @State var LocationsData : [Location] = []
    
    @State var MarkerPoint = Location()
    @State var IsanimateMap = false
    
    @State var Locationstatus = false
    @State var Errormessage : String = "No Location History"
    var body: some View {
        ZStack{
            VStack(spacing: 0){
                
                CustomNavigationTitleView(userName: "Locations",ShowSwitchUserView:$ShowSwitchUserView)
                
                
                if Locationstatus {
                    if !LocationsData.filter({$0.Userid == UserDefaults.standard.string(forKey: "isLogged") ?? "1"}).isEmpty {
                        List{
                            ForEach(LocationsData.filter({$0.Userid == UserDefaults.standard.string(forKey: "isLogged") ?? "1"}),id:\.self) { location in
                                Text(location.Locationname)
                                    .fontWeight(.regular)
                                    .onTapGesture {
                                        MarkerPoint = location
                                        ShowMapView.toggle()
                                    }
                            }
                        }
                    }else{
                        VStack{
                            Spacer()
                            Text(Errormessage)
                                .font(.subheadline)
                                .foregroundStyle(.black)
                                .multilineTextAlignment(.center)
                            Spacer()
                        }
                    }
                }else{
                    VStack{
                        Spacer()
                        Text(Errormessage)
                            .font(.subheadline)
                            .foregroundStyle(.black)
                        Spacer()
                    }
                }
                
            }
            .onAppear(perform: {
                DispatchQueue.main.async {
                    LocationsData.removeAll()
                    LocationsData = locationManagervm.fetchData()
                    
                    //                    if CLLocationManager.locationServicesEnabled() {
                    switch CLLocationManager.authorizationStatus() {
                    case .authorizedWhenInUse, .authorizedAlways:
                        Locationstatus = true
                    case .notDetermined:
                        Locationstatus = false
                        Errormessage = "Location services are notDetermined.\nPlease enable location services for this app in Settings."
                    case .denied, .restricted:
                        Locationstatus = false
                        Errormessage = "Location services are disabled.\nPlease enable location services for this app in Settings."
                    @unknown default:
                        fatalError("Unknown case.")
                    }
                    //                    }
                }
            })
            
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("Location"))){
                _ in
                DispatchQueue.main.async {
                    LocationsData.removeAll()
                    LocationsData = locationManagervm.fetchData()
                }
            }
            
            if ShowSwitchUserView{
                SwitchUserViews()
            }
            
            if ShowMapView {
                ZStack(alignment: .top){
                    GoogleMapsView(Markerpoint: $MarkerPoint, coordinates: $locationManagervm.coordinates, StartPoint: $locationManagervm.coordinate2D,IsanimateMap:$IsanimateMap)
                        .ignoresSafeArea()
                    
                    HStack{
                        Button(action: {
                            IsanimateMap = false
                            ShowMapView.toggle()
                        }, label: {
                            Image(systemName: "xmark")
                                .bold()
                                .font(.caption2)
                                .foregroundColor(.black)
                                .padding(10)
                                .background(Color.white)
                                .clipShape(Circle())
                        })
                        Spacer()
                    }.padding([.top,.leading],5)
                    
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                DispatchQueue.main.async {
                                    withAnimation(){
                                        //                                        if locationManagervm.fetchData().count > 1 {
                                        locationManagervm.FetchPolyline()
                                        //                                        }
                                        
                                        IsanimateMap.toggle()
                                    }
                                }
                            },label: {
                                Image(systemName: IsanimateMap ? "pause.fill" : "play.fill")
                                    .font(.headline)
                                    .foregroundColor(.black.opacity(0.6))
                            })
                            .background(
                                ZStack{
                                    Circle()
                                        .frame(width:55, height: 55)
                                    Circle()
                                        .shadow(color: Color.black.opacity(0.2), radius: 2,x: 0,y: 3)
                                    Circle()
                                        .fill(Color.white)
                                    
                                }
                            )
                            
                        }
                        .padding()
                        .padding(.bottom,80)
                        .padding(.trailing,14)
                    }
                    
                }
            }
            
            
        }.navigationBarHidden(true)
        
    }
    
}



extension LocationListView {
    @ViewBuilder
    func SwitchUserViews() ->  some View {
        ZStack{
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    ShowSwitchUserView.toggle()
                }
            
            SwitchUserView(ShowSwitchUser:$ShowSwitchUserView)
                .transition(.scale)
        }
    }
}
