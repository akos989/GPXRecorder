//
//  ViewController.swift
//  GPXRecorder
//
//  Created by Ákos Morvai on 2023. 04. 28..
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var numberOfRecordedItems: UILabel!
    
    @IBOutlet var recordButton: UIButton!
    
    var isRecording = false {
        didSet {
            if isRecording {
                titleLabel.text = "Recording..."
                recordButton.titleLabel?.text = "Stop recording"
            } else {
                titleLabel.text = "Not recording..."
                recordButton.titleLabel?.text = "Start recording"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("view loaded")
    }

    

    @IBAction func recordButtonPressed(_ sender: UIButton) {
        isRecording.toggle()
    }
}

