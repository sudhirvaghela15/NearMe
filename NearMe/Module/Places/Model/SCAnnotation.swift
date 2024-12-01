//
//  SCAnnotation.swift
//  NearMe
//
//  Created by sudhir on 01/12/24.
//

import Foundation

public class SCAnnotation: NSObject, Decodable {
	private let placemark: SCPlacemark
	
	public var id: UUID  = .init()
	public var isSelected: Bool? = false

	public init(placemark: SCPlacemark) {
		self.placemark = placemark
	}
	
	public init(mapItem: MKMapItem) {
		self.placemark = SCPlacemark(placemark: mapItem.placemark)
	}
}


import MapKit

extension SCAnnotation: MKAnnotation {
	
	public var title: String? {
		placemark.name
	}
	
	public var subtitle: String? {
		placemark.title
	}
	public var coordinate: CLLocationCoordinate2D {
		placemark.coordinate
	}
	
	public var location: CLLocation {
		CLLocation(
			latitude: coordinate.latitude,
			longitude: coordinate.longitude
		)
	}
}
