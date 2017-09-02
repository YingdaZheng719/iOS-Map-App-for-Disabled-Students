//
//  ViewController.swift
//  UWF_ADA_Map
//
//  Created by Yingda Zheng on 3/29/16.
//  Copyright © 2016 Yingda Zheng. All rights reserved.
//

import UIKit

import MapKit
import CoreLocation

let uwfCenter = CLLocationCoordinate2D(latitude: 30.548619, longitude: -87.218410)
let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
let defaultArea = MKCoordinateRegionMake(uwfCenter, defaultSpan)

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchText: UITextField!
    var matchingItems: [MKMapItem] = [MKMapItem]()
    var isShownParkingLocation = false
    var isShownBuildingLocations = false
    
    var locationManager = CLLocationManager()
    //create an instance for managering the parking locations
    var parkingLocationsModel = ParkingLocationManager()
    
    var tbc = MapTabController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.mapView.delegate = self
        
        self.mapView.setRegion(defaultArea, animated: false) // Zoom into the UWF Campus
        
        self.locationManager.requestWhenInUseAuthorization() // Ask permission to use location
        self.mapView.showsUserLocation = true // Turn on location
        
        tbc = self.tabBarController as! MapTabController
        //showBuildingLocation()
        
    }
    
    //every time the user toggle back the map view, check if there is any switch button of which status is changed
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(tbc.isTypeChanged == true) {
            tbc.isTypeChanged = false
            self.typeChange()
        }
        
        if(tbc.isShownParkingLocationChanged == true) {
            tbc.isShownParkingLocationChanged = false
            self.showParkingLocation()
        }
        
        if(tbc.isShownElevatorChanged == true) {
            tbc.isShownElevatorChanged = false
            self.showElevator()
        }
        
        if(tbc.isShownPathChanged == true) {
            tbc.isShownPathChanged = false
            self.showPath()
        }
        
        if(tbc.isShownElevationChanged == true) {
            tbc.isShownElevationChanged = false
            self.showElevation()
        }
        
        if(tbc.isShownBuildingChanged == true) {
            tbc.isShownBuildingChanged = false
            self.showBuilding()
        }
    }
    
    //show user's location
    @IBAction func showCurrentLocation(_ sender: AnyObject) {
        let cl2d = CLLocationCoordinate2D(latitude: self.mapView.userLocation.coordinate.latitude, longitude: self.mapView.userLocation.coordinate.longitude)
        
        if cl2d.latitude > 30.54248885611105 && cl2d.latitude < 30.558861176163116 && cl2d.longitude > -87.225974 && cl2d.longitude < -87.19855070114136{
            self.mapView.setCenter(cl2d, animated: true)
        }
        else{
            print("Error")
        }
        
        //Figure out way to alert the user that they are not in the UWF campus so they will not show up!!
    }
    
    //show the region of UWF
    @IBAction func showUWFLocation(_ sender: AnyObject) {
        let cl2d = CLLocationCoordinate2D(latitude: 30.548619, longitude: -87.218410)
        
        //change the displayed region of the map using map view setRegion method
        self.mapView.setCenter(cl2d, animated: true)
    }
    
    //========================================================================================================================
    //change the type of map between standard and satellite
    func typeChange() {
        if mapView.mapType == MKMapType.standard {
            mapView.mapType = MKMapType.satellite
        } else {
            mapView.mapType = MKMapType.standard
        }
    }
    
    //show or hide parking location annotions
    
    func showParkingLocation() {
        
        
        if(isShownParkingLocation == false) {
            
            var parkingData = [Placemark]()
            parkingData = ParkingLocationManager()
            
            for i in 0 ..< parkingData.count{
                //Create a MKPointAnnotation
                let annotation = CustomPointAnnotation()
                let cl2d = CLLocationCoordinate2D(latitude: parkingData[i].lookAt.latitude , longitude: parkingData[i].lookAt.longitude)
                
                //annotation.coordinate = location.
                annotation.coordinate = cl2d
                
                //self.zoomOnLocation(annotation.coordinate)
                annotation.title = parkingData[i].name
                //annotation.subtitle = parkingData[i].description
                
                annotation.imageName = "ParkingLotIcon.png"
                annotation.subtitle = "parking"
                //Add annotation to the map
                self.mapView.addAnnotation(annotation)
            }
            isShownParkingLocation = true
        } else {
            let annotationsToRemove = mapView.annotations.filter { $0.subtitle! == "parking" }
            mapView.removeAnnotations( annotationsToRemove )
            
            isShownParkingLocation = false
        }
    }
    
    //show or hide parking Building annotions
    
    func showBuildingLocation() {
        
        if(isShownBuilding == false) {
            var buildingsData = [Placemark]()
            buildingsData = BuildingLocationManager()
            
            for i in 0 ..< buildingsData.count{
                //Create a MKPointAnnotation
                let annotation = CustomPointAnnotation()
                let cl2d = CLLocationCoordinate2D(latitude: buildingsData[i].coordinates[0].Y , longitude: buildingsData[i].coordinates[0].X)
                
                //annotation.coordinate = location.
                annotation.coordinate = cl2d
                
                //self.zoomOnLocation(annotation.coordinate)
                annotation.title = buildingsData[i].name
                
                annotation.imageName = "Icon_Existing_Building.jpg"
                annotation.subtitle = "building"
                //Add annotation to the map
                self.mapView.addAnnotation(annotation)
            }
            isShownBuilding = true
        } else {
            let annotationsToRemove = mapView.annotations.filter { $0.subtitle! == "building" }
            mapView.removeAnnotations( annotationsToRemove )
            
            isShownBuilding = false
        }
    }
    
    func showElevatorLocation() {
        
        if(isShownElevator == false) {
            var elevatorData = [Placemark]()
            elevatorData = ElevatorLocationManager()
            
            for i in 0 ..< elevatorData.count{

                    //Create a MKPointAnnotation
                    let annotation = CustomPointAnnotation()
                    let cl2d = CLLocationCoordinate2D(latitude: elevatorData[i].coordinates[0].Y , longitude: elevatorData[i].coordinates[0].X)
                    
                    //annotation.coordinate = location.
                    annotation.coordinate = cl2d
                    
                    //self.zoomOnLocation(annotation.coordinate)
                    annotation.title = elevatorData[i].name
                    
                    annotation.imageName = "elevator.png"
                    annotation.subtitle = "elevator"
                    //Add annotation to the map
                    self.mapView.addAnnotation(annotation)

            }
            isShownElevator = true
        } else {
            let annotationsToRemove = mapView.annotations.filter { $0.subtitle! == "elevator"}
            mapView.removeAnnotations( annotationsToRemove )
            
            isShownElevator = false
        }
    }
    //show or hide elevators
    var isShownElevator = false
    func showElevator() {
        showElevatorLocation()
    }
    
    //show or hide paths
    var isShownPath = false
    func showPath() {
        if(isShownPath == false) {
            
            
            isShownPath = true
        } else {
            
            
            isShownPath = false
        }
    }
    
    //show or hide elevations
    var isShownElevation = false
    func showElevation() {
        if(isShownElevation == false) {
            
            
            isShownElevation = true
        } else {
            
            isShownElevation = false
        }
    }
    
    //show or hide buildings
    var isShownBuilding = false
    func showBuilding() {
        showBuildingLocation()
    }
    
    //================================================================================================================
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    func zoomOnLocation(location:CLLocationCoordinate2D){
        let span = MKCoordinateSpan(latitudeDelta: 10.907872, longitudeDelta: 10.9109863)
        let newRegion: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        self.mapView.setRegion(newRegion, animated: true)
    }
    */
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if !(annotation is CustomPointAnnotation) {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        
        let reuseid = "test"
        
        var mp = mapView.dequeueReusableAnnotationView(withIdentifier: reuseid)
        
        
        
        if mp == nil {
            mp = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseid)
            mp!.canShowCallout = true
            
            let b: UIButton = UIButton(type: UIButtonType.detailDisclosure) as UIButton
            mp!.rightCalloutAccessoryView = b
            
            
        } else {
            mp!.annotation = annotation
        }
        
        let cpa = annotation as! CustomPointAnnotation
        mp!.image = UIImage(named: cpa.imageName)
        return mp
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool){ //Keep you in the UWF campus
        let centerCoord: CLLocationCoordinate2D = CLLocationCoordinate2DMake(Clamp(30.54248885611105, max: 30.558861176163116, value: mapView.region.center.latitude), Clamp(-87.225974, max: -87.19855070114136, value: mapView.region.center.longitude))
        
        if mapView.region.span.latitudeDelta > defaultSpan.latitudeDelta {
            mapView.region.span = defaultSpan
        }
        
        mapView.setCenter(centerCoord, animated: true) // Keeps you within the UWF Campus
        
    }
    func Clamp(_ min: Double, max : Double, value : Double) -> Double{
        if (value < min){
            return min
        }
        if (value > max){
            return max
        }
        return value
    }
    
    //When search of textfield is triggered
    @IBAction func textFieldReturn(_ sender: AnyObject) {
        //hide the keyboard
        sender.resignFirstResponder()
        //perform seach and add annotations
        //self.performSearch()
    }
    
    /*func performSearch() {
        
        //remove the previous search result from the map
        let annotationsToRemove = mapView.annotations.filter { $0.subtitle! == "search" }
        mapView.removeAnnotations( annotationsToRemove )
        matchingItems.removeAll()
        
        let request = MKLocalSearchRequest()
        if(searchText.text == "") {
            return;
        }
        request.naturalLanguageQuery = searchText.text
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.startWithCompletionHandler({(response:
            MKLocalSearchResponse?, error: NSError?) in
            
            if error != nil {
                print("Error occured in search: \(error!.localizedDescription)")
            } else if response!.mapItems.count == 0 {
                print("No matches found")
            } else {
                print("Matches found")
                
                for item in response!.mapItems {
                    print("Name = \(item.name)")
                    print("Phone = \(item.phoneNumber)")
                    
                    self.matchingItems.append(item as MKMapItem)
                    print("Matching items = \(self.matchingItems.count)")
                    
                    let annotation = CustomPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    annotation.subtitle = "search"
                    annotation.imageName = "search_icon.png"
                    
                    self.mapView.addAnnotation(annotation)
                    
                }
            }
            
        })
    }*/
    
    
}

