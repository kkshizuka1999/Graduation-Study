//
//  ViewController.swift
//  MapKitDemo
//
//  Created by IKEchannel on 2020/08/04.
//  Copyright © 2020 IKEchannel. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Photos

class ViewController: UIViewController, CLLocationManagerDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    var locManager: CLLocationManager!
    @IBOutlet var longPressGesRec: UILongPressGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initMap()
        locManager = CLLocationManager()
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                locManager.startUpdatingLocation()
                break
            default:
                break
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]){
        let lonStr = (locations.last?.coordinate.longitude.description)!
        let latStr = (locations.last?.coordinate.latitude.description)!
        print("lon : " + lonStr)
        print("lat : " + latStr)
        updateCurrentPos((locations.last?.coordinate)!)
    }
    func initMap(){
        var region:MKCoordinateRegion = mapView.region
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        mapView.setRegion(region, animated: true)
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
    func updateCurrentPos(_ coordinate:CLLocationCoordinate2D) {
        var region:MKCoordinateRegion = mapView.region
        region.center = coordinate
        mapView.setRegion(region, animated: true)
    }
    // UILongPressGestureRecognizerのdelegate：ロングタップを検出する
    @IBAction func mapViewDidLongPress(_ sender: UILongPressGestureRecognizer) {
        // ロングタップ開始
        if sender.state == .began {
        }
        // ロングタップ終了（手を離した）
        else if sender.state == .ended {
            let tapPoint = sender.location(in: view)
            let center = mapView.convert(tapPoint, toCoordinateFrom: mapView)

            let lonStr = center.longitude.description
            let latStr = center.latitude.description
            print("lon : " + lonStr)
            print("lat : " + latStr)
        }
        
    }
    
    @IBAction func camera(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        // UIImagePickerController カメラを起動する
        present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        
        var metadata = info[UIImagePickerController.InfoKey.mediaMetadata] as? NSDictionary

        // Exifの参照を取得
        let exif = metadata?.object(forKey: kCGImagePropertyExifDictionary)
        print(exif)
        
        let gps = metadata?.object(forKey: kCGImagePropertyGPSDictionary)
        
        // "写真を使用"を押下した際、写真アプリに保存する
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        // UIImagePickerController カメラが閉じる
        self.dismiss(animated: true, completion: nil)
    }
}
