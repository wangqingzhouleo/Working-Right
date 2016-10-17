//
//  LegalServiceViewController.swift
//  Working Rights
//
//  Created by Qingzhou Wang on 28/08/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LegalServiceViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, SelectCategoryDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var locationManager = CLLocationManager()
    var legalServiceList: [LegalServiceAnnotation] = []
    var routePolylines = [MKPolyline]()
    var allFields: [String: String] = ["All": "All"]
    var categoryList: [String] = []
    
    var selectedServiceIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        mapView.zoomEnabled = true
        mapView.delegate = self
        locationManager.delegate = self
        
        loadData()
        setDefaultRegion()
        setFirstToolbarButton()
        
        navigationItem.title = "All"
        
        showOfficeOnMap("All")
        
        let rightButton = UIBarButtonItem(image: UIImage(named: "bar button item - list"), style: .Plain, target: self, action: #selector(self.selectField))
        navigationItem.rightBarButtonItem = rightButton
        let leftButton = UIBarButtonItem()
        leftButton.title = "Back"
        navigationItem.backBarButtonItem = leftButton
        
        for key in allFields.keys
        {
            categoryList.append(key)
        }
        categoryList.sortInPlace()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectField()
    {
        let categoryTableController = ServiceCategoryTableViewController(style: .Grouped)
        
        categoryTableController.categoryList = self.categoryList
        categoryTableController.delegate = self
        categoryTableController.selectedIndex = selectedServiceIndex
        showViewController(categoryTableController, sender: self)
    }
    
    func loadData()
    {
        // Load data from json file
        if let path = NSBundle.mainBundle().pathForResource("Legal Service", ofType: "json")
        {
            do
            {
                let jsonData = try NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
                let result = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers) as! [NSDictionary]
                
                for item in result
                {
                    let field = item["field"] as! String
                    allFields.updateValue(field, forKey: field)
                    let name = item["name"] as! String
                    let addressList = item["address"] as! NSArray
                    let tollFree = item["tollFree"] as? String
                    
                    for item in addressList
                    {
                        let address = item["address"] as! String
                        let tel = item["tel"] as! String
                        let lat = item["lat"] as! Double
                        let long = item["long"] as! Double
                        legalServiceList.append(LegalServiceAnnotation(title: name, subtitle: address, address: address, tel: tel, tollFree: tollFree, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long), field: field))
                    }
                }
            }
            catch
            {
                print("Error when loading Legal Service json")
            }
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        // Check the annotation if it's not LogalServiceAnnotation then return nil to display default view.
        if !annotation.isKindOfClass(LegalServiceAnnotation)
        {
            return nil
        }
        else
        {
//            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            let view = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            view.enabled = true
            view.canShowCallout = true
//            view.animatesDrop = true
            view.image = UIImage(named: "category - \((annotation as! LegalServiceAnnotation).field)")
            
            view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            view.tintColor = UIColor(red: 0.8471, green: 0, blue: 0.1529, alpha: 1)
            return view
        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // When any pin is tapped, show an alert which contains some information about that branch with further options: Get direction or Call
        if let office = view.annotation as? LegalServiceAnnotation
        {
            let alert = UIAlertController(title: office.title, message: "", preferredStyle: .Alert)
            
            alert.message = "Address: \(office.address)\nTel: \(office.tel)"
            alert.addAction(UIAlertAction(title: "Get Direction", style: .Default, handler: {
                (alert: UIAlertAction) in self.getDirection(office)
            }))
            alert.addAction(UIAlertAction(title: "Call", style: .Default, handler: {
                (alert: UIAlertAction) in self.makePhoneCall(office)
            }))
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func makePhoneCall(office: LegalServiceAnnotation)
    {
        // Call the company after user confirm the action
        let alert = UIAlertController(title: office.tel, message: "", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Call", style: .Default, handler: {
            (alert: UIAlertAction) in
            if let url = NSURL(string: "tel://\(office.tel.stringByReplacingOccurrencesOfString(" ", withString: ""))")
            {
                UIApplication.sharedApplication().openURL(url)
            }
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func showOfficeOnMap(field: String)
    {
        mapView.removeAnnotations(mapView.annotations)
        for office in legalServiceList
        {
            if field == "All"
            {
                mapView.addAnnotation(office)
            }
            else if field == office.field
            {
                mapView.addAnnotation(office)
            }
        }
    }
    
    func setDefaultRegion()
    {
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = -37.877623
        annotation.coordinate.longitude = 145.045374
        let regionRadius: CLLocationDistance = 80000
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(annotation.coordinate, regionRadius, regionRadius), animated: true)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        default:
            locationManager.requestWhenInUseAuthorization()
            mapView.showsUserLocation = false
        }
    }
    
    func getDirection(office: LegalServiceAnnotation)
    {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        alert.addAction(UIAlertAction(title: "Show Route", style: .Default, handler: {
            (alert: UIAlertAction) in self.showRoute(office)
        }))
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: "comgooglemaps://")!)
        {
            alert.addAction(UIAlertAction(title: "Navigate by Google Maps", style: .Default, handler: {
                (alert: UIAlertAction) in self.openGoogleMap(office)
            }))
        }
        alert.addAction(UIAlertAction(title: "Navigate by Apple Maps", style: .Default, handler: {
            (alert: UIAlertAction) in self.openAppleMap(office)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func openGoogleMap(office: LegalServiceAnnotation)
    {
        let url = NSURL(string: "comgooglemaps://?daddr=\(office.address.stringByReplacingOccurrencesOfString(" ", withString: "+"))&directionsmode=driving")!
        UIApplication.sharedApplication().openURL(url)
    }
    
    func openAppleMap(office: LegalServiceAnnotation)
    {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: office.coordinate, addressDictionary: nil))
        mapItem.name = office.address
        let launchOptions: NSDictionary = NSDictionary(object: MKLaunchOptionsDirectionsModeDriving, forKey: MKLaunchOptionsDirectionsModeKey)
        
        MKMapItem.openMapsWithItems([MKMapItem.mapItemForCurrentLocation(), mapItem], launchOptions: launchOptions as? [String : AnyObject])
    }
    
    func showRoute(office: LegalServiceAnnotation)
    {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse || CLLocationManager.authorizationStatus() == .AuthorizedAlways
        {
            clearRoute()
            let request = MKDirectionsRequest()
            request.source = MKMapItem.mapItemForCurrentLocation()
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: office.coordinate, addressDictionary: nil))
            request.requestsAlternateRoutes = false
            request.transportType = .Automobile
            
            let directions = MKDirections(request: request)
            directions.calculateDirectionsWithCompletionHandler({ (response: MKDirectionsResponse?, error: NSError?) in
                guard response != nil else {return}
                
                for route in response!.routes
                {
                    self.mapView.addOverlay(route.polyline)
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsetsMake(100, 80, 100, 80), animated: true)
                    self.routePolylines.append(route.polyline)
                }
                
                // Add a cancen button at the right side of the toolbar. When the button is pressed, cancel the route.
                let cancelButton = UIBarButtonItem(title: "Clear", style: .Plain, target: self, action: #selector(self.clearRoute))
                self.toolBar.items?.append(cancelButton)
            })
        }
        else
        {
            let alert = UIAlertController(title: "Location Services Off", message: "Turn on Location Services in Settings > Privacy to allow Working Rights to determine your current location", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func clearRoute()
    {
        // Remove all overlays on the map in order to clear the route
        mapView.removeOverlays(routePolylines)
        routePolylines.removeAll()
        if toolBar.items?.count > 2
        {
            toolBar.items?.removeLast()
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        render.strokeColor = UIColor(red: 0.3490, green: 0.6471, blue: 0.9647, alpha: 1)
        return render
    }
    
//    func mapViewWillStartRenderingMap(mapView: MKMapView) {
//        if mapView.overlays.first != nil
//        {
//            mapView.setVisibleMapRect(mapView.overlays.first!.boundingMapRect, edgePadding: UIEdgeInsetsMake(80, 80, 80, 80), animated: true)
//        }
//    }
    
    func setFirstToolbarButton()
    {
        // Create a button at left of the toolbar, indicate whether the map's center is user's current location
        let button = MKUserTrackingBarButtonItem(mapView: mapView)
        button.target = self
        toolBar.items?.append(button)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        self.toolBar.items?.append(flexibleSpace)
    }
    
    func mapView(mapView: MKMapView, didChangeUserTrackingMode mode: MKUserTrackingMode, animated: Bool) {
        if CLLocationManager.authorizationStatus() != .AuthorizedWhenInUse
        {
            // If location service is off, tell user the message and method to open it.
            let alert = UIAlertController(title: "Location Services Off", message: "Turn on Location Services in Settings > Privacy to allow Working Rights to determine your current location", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func didSelectCategory(field: String, index: Int) {
        navigationItem.title = field
        selectedServiceIndex = index
        showOfficeOnMap(field)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
