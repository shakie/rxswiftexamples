//
//  ViewModelViewController.swift
//  RxSwiftExamples
//
//  Created by Shaun Rowe on 22/10/2017.
//  Copyright © 2017 Shaun Rowe. All rights reserved.
//

import UIKit
import RxSwift
import SVProgressHUD

class ViewModelViewController: UIViewController {
    
    let disposables = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension ViewModelViewController {
    
    func setupStatusPublisherObservable(_ publisher: StatusPublisher) {
        publisher.statusPublisher.observeOn(MainScheduler.instance)
            .subscribe(onNext: { status in
                if status.showHud {
                    SVProgressHUD.show(withStatus: status.message ?? "")
                } else {
                    SVProgressHUD.dismiss()
                }
            }).disposed(by: disposables)
    }
    
    internal func showOfflineAlert() {
        SVProgressHUD.dismiss()
        let alert = UIAlertController(title: "Offline", message: "You appear to be offline. The app will not function as expeted without an internet connection", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
