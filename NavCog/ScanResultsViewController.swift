//
//  ScanResultsViewController.swift
//  NavCog
//
//  Created by Harsh Agarwal on 11/7/19.
//  Copyright © 2019 Vivek Roy. All rights reserved.
//

import UIKit
import CoreLocation
import DeepDiff


extension CLBeacon : DiffAware {
    public var diffId: DiffId {
        "\(major.intValue)_\(minor.intValue)"
    }
    
    public static func compareContent(_ a: CLBeacon, _ b: CLBeacon) -> Bool {
        return a.rssi == b.rssi
    }
    
    public typealias DiffId = String
    
    func toBeacon() -> Beacon {
        return Beacon(major: major.intValue, minor: minor.intValue, rssi: rssi)
    }
}


class TableOps : NSObject, UITableViewDataSource, UITableViewDelegate {
    private var beacons_test = [Beacon](
        arrayLiteral: Beacon(major: 65537, minor: 7, rssi: -72),
        Beacon(major: 65535, minor: 11, rssi: -90),
        Beacon(major: 65530, minor: 13, rssi: -20)
    )
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAt")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BeaconTableViewCell", for: indexPath) as? BeaconTableViewCell else {
                fatalError("The dequeued cell is not an instance of MealTableViewCell.")
            }
        
        let b = beacons_test[indexPath.row]
        cell.major.text = String(b.major)
        cell.minor.text = String(b.minor)
        cell.rssi.text = String(b.rssi)
        
        return cell
    }
}


class ScanResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    private var locationManager : CLLocationManager? = CLLocationManager()
    private let proximityUUID = UUID(uuidString: "F7826DA6-4FA2-4E98-8024-BC5B71E0893E")!
    private var old_list = [CLBeacon]()
    @IBOutlet weak var tableview: UITableView!
    @IBAction func stopTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager?.requestWhenInUseAuthorization()
        if !CLLocationManager.isRangingAvailable() {
            locationManager = nil
        }
        locationManager?.delegate = self
        locationManager?.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: proximityUUID))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         locationManager?.stopRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: proximityUUID))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return old_list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BeaconTableViewCell", for: indexPath) as? BeaconTableViewCell else {
                fatalError("The dequeued cell is not an instance of MealTableViewCell.")
            }
        let item = old_list[indexPath.item]
        cell.major.text = String(item.major.intValue)
        cell.minor.text = String(item.minor.intValue)
        cell.rssi.text = String(item.rssi)
        return cell
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didRangeBeacons beacons: [CLBeacon],
                         in region: CLBeaconRegion) {
        let beacons_new = beacons.filter { $0.rssi != 0 }
        if beacons_new.count > 0 {
            let changes = diff(old: self.old_list, new: beacons_new)
            self.tableview.reload(changes: changes, section: 0, updateData:  { self.old_list = beacons_new })
        }
    }
}
