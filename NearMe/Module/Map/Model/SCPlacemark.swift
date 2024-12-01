//
//  SCPlacemark.swift
//  NearMe
//
//  Created by sudhir on 01/12/24.
//

import Foundation
import MapKit
import Contacts.CNPostalAddress

public class SCPlacemark: Decodable, Identifiable {
	public var id: UUID = UUID.init()
	
	public var name: String?
	public var title: String?
	public var subtitle: String?
	public var coordinate: CLLocationCoordinate2D
//	public var location: CLLocation?
	
	/// postal Address properties
	public var street: String?
	public var city: String?
	public var state: String?
	
	init(title: String? = nil,
		subtitle: String? = nil,
		coordinate: CLLocationCoordinate2D,
		street: String? = nil,
		city: String? = nil,
		state: String? = nil,
		location: CLLocation? = nil) {
		self.title = title
		self.subtitle = subtitle
		self.coordinate = coordinate
		self.street = street
		self.city = city
		self.state = state
//		self.location = location
	}
	
	init(placemark: MKPlacemark) {
		self.title = placemark.title
		self.name = placemark.name
//		self.location = placemark.location
		
		self.subtitle = placemark.subtitle
		self.coordinate = placemark.coordinate
		self.street = placemark.postalAddress?.street
		self.city = placemark.postalAddress?.city
		self.state = placemark.postalAddress?.state
	}
}
