//
//  ViewController.swift
//  KutahyaUlasim
//
//  Created by Berkant Beğdilili on 27.05.2020.
//  Copyright © 2020 Berkant Beğdilili. All rights reserved.
//

import UIKit
import GoogleMaps
import GoogleMapsUtils

class ViewController: UIViewController{

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var timeView: UIView!
    
    //
    @IBOutlet weak var time11: UILabel!
    @IBOutlet weak var time12: UILabel!
    @IBOutlet weak var time21: UILabel!
    @IBOutlet weak var time22: UILabel!
    
    let ulasim = UlasimData()
    private var renderer: GMUGeometryRenderer!
    private var kmlParser: GMUKMLParser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupMapView()
        
        fetchData()
        
        // Tıp Fakültesi Kalkış
        for p1 in ulasim.parsed1! {
            if p1>=ulasim.clock!{
                time12.text = String(p1)
                break
            }
            
            time11.text = String(p1)
        }
        
        //  Dokuzlar Kalkış
        for p2 in ulasim.parsed2! {
            if p2>=ulasim.clock!{
                time22.text = String(p2)
                break
            }
            
            time21.text = String(p2)
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }
    
    func fetchData(){
        ulasim.dateFormatter()
        ulasim.getData()
        ulasim.dataParse()
    }
    
    func setupMapView(){
        
        // Kamerayı DPU Kordinatlarına Getirme
        let camera = GMSCameraPosition(latitude: 39.4822726, longitude: 29.8923525, zoom: 15)
        
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        
        // Map Stili Değiştirme
        do {
          if let styleURL = Bundle.main.url(forResource: "AubergineMapStyle", withExtension: "json") {
            mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
          } else {
            NSLog("Unable to find style.json")
          }
        } catch {
          NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        // Harita Ayarları
        mapView.settings.compassButton = true
        mapView.settings.allowScrollGesturesDuringRotateOrZoom = true
        
        // Rota Çizme
        let path = Bundle.main.path(forResource: "ring", ofType: "kml")
        let url = URL(fileURLWithPath: path!)
        kmlParser = GMUKMLParser(url: url)
        kmlParser.parse()

        renderer = GMUGeometryRenderer(map: mapView,
                                       geometries: kmlParser.placemarks,
                                       styles: kmlParser.styles)

        renderer.render()
        
        
        // Ekranda Gösterme
        self.view = mapView
        
        self.view.addSubview(timeView)

        let cons1 = NSLayoutConstraint(item: timeView!,
                                     attribute: .trailing,
                                     relatedBy: .equal,
                                     toItem: view,
                                     attribute: .trailing,
                                     multiplier: 1,
                                     constant: 0)

        let cons2 = NSLayoutConstraint(item: timeView!,
                                       attribute: .leading,
                                       relatedBy: .equal,
                                       toItem: view,
                                       attribute: .leading,
                                       multiplier: 1,
                                       constant: 0)

        let cons3 = NSLayoutConstraint(item: view!,
                                       attribute: .bottom,
                                       relatedBy: .equal,
                                       toItem: timeView,
                                       attribute: .bottom,
                                       multiplier: 1,
                                       constant: 35)

        self.view.addConstraints([cons1,cons2,cons3])
          
    }
}
    


