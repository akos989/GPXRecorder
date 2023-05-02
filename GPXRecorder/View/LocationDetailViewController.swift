//
//  LocationDetailViewController.swift
//  GPXRecorder
//
//  Created by gpstuner on 2023. 05. 02..
//

import UIKit

class LocationDetailViewController: UITableViewController {

    var gpxData: GpxData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "WptCell")

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(shareXML))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gpxData.wpt.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WptCell", for: indexPath)

        let location = gpxData.wpt[indexPath.row]
        cell.textLabel?.text = "(\(location.lat), \(location.long)) at \(location.time)"
        
        return cell
    }
    
    @objc func shareXML() {
        if let fileUrl = createXML(coordinates: gpxData.wpt) {
            let activityViewController = UIActivityViewController(activityItems: [fileUrl], applicationActivities: nil)
            
            present(activityViewController, animated: true)
        }
    }
    
    func createXML(coordinates: [GpxCoordinate]) -> URL? {
        var xmlString = "<?xml version=\"1.0\"?><gpx version=\"1.1\" creator=\"Xcode\">"
        for coordinate in coordinates {
            xmlString.append("<wpt lat=\"\(coordinate.lat)\" lon=\"\(coordinate.long)\"><time>\(coordinate.time.formatted(.iso8601))</time></wpt>")
        }
        xmlString.append("</gpx>")
        
        let tempDirectoryURL = NSURL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let fileURL = tempDirectoryURL.appendingPathComponent("drive.gpx")
        
        if let url = fileURL {
            do {
                try xmlString.write(to: url, atomically: true, encoding: .utf8)
                return url
            } catch {
                print("error: \(error)")
            }
        }
        return nil
    }
}
