//
//  CodingKeys.swift
//  NearMe
//
//  Created by sudhir on 01/12/24.
//

import MapKit

extension CLLocationCoordinate2D: Codable {
	public enum CodingKeys: String, CodingKey {
		case latitude, longitude
	}
	
	public init(from decoder: any Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		let lat = try values.decode(Double.self, forKey: .latitude)
		let long = try values.decode(Double.self, forKey: .longitude)
		self.init(latitude: lat, longitude: long)
	}
	
	public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(latitude, forKey: .latitude)
		try container.encode(longitude, forKey: .longitude)
	}
}
