//
//  CompanyViewController.swift
//  RxSwiftExamples
//
//  Created by Shaun Rowe on 19/10/2017.
//  Copyright © 2017 Shaun Rowe. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class CompanyViewController: ViewModelViewController {

    @IBOutlet weak var labelCompanyName: UILabel!
    @IBOutlet weak var labelSymbol: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelClosingPrice: UILabel!
    @IBOutlet weak var labelLatestPrice: UILabel!
    @IBOutlet weak var labelDifference: UILabel!
    @IBOutlet weak var labelLastUpdate: UILabel!
    
    let viewModel = CompanyViewModel()
    var symbol: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        setupObservables()
        guard let symbol = self.symbol else {
            return
        }
        viewModel.update(symbol)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.close()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK: - Rx
extension CompanyViewController {
    
    fileprivate func setupObservables() {
        setupStatusPublisherObservable(viewModel)
        setupReachabilityObserver()
        bindLabelToObservable(labelCompanyName, observable: viewModel.companyName.asObservable())
        bindLabelToObservable(labelSymbol, observable: viewModel.symbol.asObservable())
        bindLabelToObservable(labelDescription, observable: viewModel.description.asObservable())
        bindLabelToObservable(labelLatestPrice, observable: viewModel.latestPriceFormatted.asObservable())
        bindLabelToObservable(labelClosingPrice, observable: viewModel.closingPriceFormatted.asObservable())
        bindLabelToObservable(labelDifference, observable: viewModel.differenceFormatted.asObservable())
        bindLabelToObservable(labelLastUpdate, observable: viewModel.lastUpdated.asObservable())
    }

    private func setupReachabilityObserver() {
        Observable.combineLatest(viewModel.apiReachable, viewModel.webSocketReachable)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] api, socket in
                if api && socket {
                    self?.labelLastUpdate.textColor = UIColor.green
                } else if api && !socket {
                    self?.labelLastUpdate.textColor = .orange
                } else if !api && !socket {
                    self?.labelLastUpdate.textColor = .red
                    self?.showOfflineAlert()
                }
            }).disposed(by: disposables)
    }
    
    private func bindLabelToObservable(_ label: UILabel, observable: Observable<String>) {
        observable.observeOn(MainScheduler.instance)
            .bind(to: label.rx.text)
            .disposed(by: disposables)
    }
    
}
