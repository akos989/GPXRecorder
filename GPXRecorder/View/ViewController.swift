//
//  ViewController.swift
//  GPXRecorder
//
//  Created by Ákos Morvai on 2023. 04. 28..
//

import RxCocoa
import RxSwift
import UIKit

class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var numberOfRecordedItems: UILabel!
    
    @IBOutlet var recordButton: UIButton!
        
    var isRecording = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "Record route"
        
        setupBindings()
    }

    func setupBindings() {
        RecorderService.shared.recordedCoordinatesNumberSubject
            .subscribe(onNext: { [weak self] number in
                self?.numberOfRecordedItems.text = "\(number) number of coordinates saved"
            })
            .disposed(by: disposeBag)
    }

    @IBAction func recordButtonPressed(_ sender: UIButton) {
        isRecording.toggle()
        
        if isRecording {
            titleLabel.text = "🟢 Recording..."
            sender.setTitle("Stop recording", for: .normal)
            sender.tintColor = .red
            
            RecorderService.shared.startRecording()
        } else {
            titleLabel.text = "🔴 Not recording..."
            sender.setTitle("Start recording", for: .normal)
            numberOfRecordedItems.text = ""
            sender.tintColor = .tintColor
            
            RecorderService.shared.stopRecording()
        }
    }
}
