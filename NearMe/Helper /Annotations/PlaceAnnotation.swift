//
//  PlaceAnnotation.swift
//  NearMe
//
//  Created by sudhir on 01/12/24.
//

import Foundation
import MapKit

class PlaceAnnotation: MKPointAnnotation {
	let mapItem: MKMapItem
	let id: UUID = .init()
	var isSelected: Bool = false
	
	init(mapItem: MKMapItem, isSelected: Bool) {
		self.mapItem = mapItem
		self.isSelected = isSelected
		super.init()
		self.coordinate = mapItem.placemark.coordinate
	}
	
	var name: String {
		mapItem.name ?? ""
	}
	
	var phone: String {
		mapItem.phoneNumber ?? ""
	}
	
	var location: CLLocation {
		mapItem.placemark.location ?? CLLocation.default
	}
	
	var address: String {
		"\(mapItem.placemark.subThoroughfare ?? "") \(mapItem.placemark.thoroughfare ?? "") \(mapItem.placemark.locality ?? "") \(mapItem.placemark.countryCode ?? "")"
	}
}
