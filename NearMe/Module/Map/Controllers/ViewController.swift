//
//  ViewController.swift
//  NearMe
//
//  Created by sudhir on 30/11/24.
//

import UIKit
import MapKit

class ViewController: UIViewController {
	
	private var locationManager: CLLocationManager?
	
	private var places: [SCAnnotation] = []
	
	lazy var mapView: MKMapView = {
		let map = MKMapView()
		map.showsUserLocation = true // enable it for showing user locaiton if location is there
		map.delegate = self
		map.translatesAutoresizingMaskIntoConstraints = false
		return map
	}()
	
	lazy var searchTextField: UITextField = {
		let textField = UITextField()
		textField.layer.cornerRadius = 10
		textField.clipsToBounds = true
		textField.backgroundColor = UIColor.white
		textField.placeholder = "Search"
		textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
		textField.leftViewMode = .always
		textField.returnKeyType = .go
		textField.delegate = self
		textField.translatesAutoresizingMaskIntoConstraints = false
		return textField
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupLocationManager()
		self.setupUI()
	}
	
	/// setup constraints and adding views on screen
	private func setupUI() {
		self.view.addSubview(searchTextField)
		self.view.addSubview(mapView)
		
		// adding  constraint and fram to map view
		self.mapView.frame = view.frame
		
		self.view.bringSubviewToFront(searchTextField)
		
		// Add some constraint to seach text field
		self.searchTextField.heightAnchor
			.constraint(equalToConstant: 44).isActive = true
		self.searchTextField.centerXAnchor
			.constraint(equalTo: view.centerXAnchor).isActive = true
		self.searchTextField.leadingAnchor
			.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
		self.searchTextField.topAnchor
			.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
	}
	
	/// location manager setup
	private func setupLocationManager() {
		self.locationManager = CLLocationManager()
		self.locationManager?.delegate = self
		self.locationManager?.requestWhenInUseAuthorization() /// add location permission key and description in info plist for when in user location
		self.locationManager?.requestAlwaysAuthorization() /// add location permission key and description in info plist for Privacy - Location Always and When In Use Usage Description
		self.locationManager?.requestLocation() // this is one time requesting to user for location
	}
	
	/// check location authorization status
	private func checkLocationAuthorization() {
		guard let locationManager, let location = locationManager.location else {
			return
		}
		let authorizationStatus = locationManager.authorizationStatus
		
		switch authorizationStatus {
			case .authorizedAlways, .authorizedWhenInUse:
				let region = MKCoordinateRegion(
					center: location.coordinate,
					latitudinalMeters: 750,
					longitudinalMeters: 750
				)
				self.mapView.setRegion(region, animated: true)
				print("location line \(#line): \(location)")
				
			case .denied:
				print("Locataion services has been denied...!")
				
			case .restricted, .notDetermined:
				print("User Restricated location permission so please enable location permission from settings for this app")
				
			@unknown default:
				print("Sorry Unknow Error \nwe are unable to fetch your location")
		}
	}
	
	/// 
	private func searchPlaces(by query: String) {
		/// if there is any annotation then clear all annotation now
		mapView.removeAnnotations(mapView.annotations)
		
		let request = MKLocalSearch.Request()
		request.naturalLanguageQuery = query
		request.region = mapView.region
		let search = MKLocalSearch(request: request)
		search.start {[weak self] result, error in
			guard let self,
				  error == nil,
				  let result = result else { return }
			print("Local Search Result = {\n ", result.mapItems, "\n}")
			self.places = result.mapItems.map(SCAnnotation.init)
			if !places.isEmpty {
				self.mapView.addAnnotations(places)
				self.presentPlacesSheet(places: places)
			}
		}
	}
	
	private func clearAllSelection() {
		self.places.forEach({ $0.isSelected = false })
	}
	
	private func presentPlacesSheet(places: [SCAnnotation]) {
		guard let locationManager, let location = locationManager.location else {
			return
		 }
		let view = PlacesTableViewController(
			userLocation: location ,
			places: places
		 )
		view.modalPresentationStyle = .pageSheet
		if let sheet =  view.sheetPresentationController {
			sheet.prefersGrabberVisible = true
			sheet.detents = [.medium(), .large()]
			self.present(view, animated: true)
		}
	}
}

// MARK: - MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, didSelect annotation: any MKAnnotation) {
		clearAllSelection()
		guard let placemark = annotation as? SCAnnotation else { return }
		let selectedPlace = self.places.first(where: { $0.id == placemark.id})
		selectedPlace?.isSelected = true
		presentPlacesSheet(places: self.places)
	}
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
	
	/// whenever location authorization chage getting call back here
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		checkLocationAuthorization()
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
		print("Location Error at \(#line) \(error.localizedDescription)")
	}
}

// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		let text = textField.text ?? ""
		if !text.isEmpty {
			textField.resignFirstResponder()
			// find near by places
			self.searchPlaces(by: text)
		}
		return true
	}
}
