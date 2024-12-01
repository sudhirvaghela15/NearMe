//
//  PlacesTableViewController.swift
//  NearMe
//
//  Created by sudhir on 01/12/24.
//

import UIKit
import MapKit

class PlacesTableViewController: UITableViewController {
	
	private let userLocation: CLLocation
	private var places: [SCAnnotation]
	
	private var isSelectedRow: Int? {
		self.places.firstIndex(where: { $0.isSelected == true })
	}
	
	init(userLocation: CLLocation, places: [SCAnnotation]) {
		self.userLocation = userLocation
		self.places = places
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable, renamed: "-")
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PlaceCell")
		self.places.swapAt(self.isSelectedRow ?? 0, 0)
    }
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		places.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath)
		let place = places[indexPath.row]

		let distance = calculateDistance(from: self.userLocation, to: place.location)
		let fomatedDistance = formateDistance(distance)
		
		var content = cell.defaultContentConfiguration()
		content.text = "\(place.title ?? "") - (\(fomatedDistance))"
		content.secondaryText = place.subtitle
		
		cell.backgroundColor = place.isSelected ?? false ? .systemCyan
			.withAlphaComponent(0.4) : UIColor.systemBackground
		
		cell.contentConfiguration = content
		
		return cell
	}
}

// MARK: - helper method's
extension PlacesTableViewController {
	private func calculateDistance(from: CLLocation, to: CLLocation) -> CLLocationDistance {
		return from.distance(from: to)
	}
	
	private func formateDistance(_ distance: CLLocationDistance) -> String {
		let meters = Measurement(value: distance, unit: UnitLength.meters)
		return meters.converted(to: .kilometers).formatted()
	}
}
