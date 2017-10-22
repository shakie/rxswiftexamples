//
//  CompanyListViewController.swift
//  RxSwiftExamples
//
//  Created by Shaun Rowe on 12/10/2017.
//  Copyright © 2017 Shaun Rowe. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SVProgressHUD

class CompanyListViewController: ViewModelViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let viewModel = CompanyListViewModel()
    let dataSource = RxTableViewSectionedReloadDataSource<SymbolSection>()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupDataSource()
        setupObservables()
        viewModel.getSymbols()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}

//MARK: - Rx
extension CompanyListViewController {
    
    fileprivate func setupDataSource() {
        dataSource.configureCell = { (ds: TableViewSectionedDataSource<SymbolSection>, tv: UITableView, indexPath: IndexPath, item: SymbolSection.Item) in
            let cell = tv.dequeueReusableCell(withIdentifier: "CompanyCell", for: indexPath)
            cell.textLabel?.text = item.name
            return cell
        }
    }
    
    fileprivate func setupObservables() {
        setupStatusPublisherObservable(viewModel)
        setupReachabilityObserver()
        setupSearch()
        
        viewModel.dataSource.asObservable().observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposables)
        
        tableView.rx.modelSelected(Symbol.self).observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] model in
                let controller = self?.storyboard?.instantiateViewController(withIdentifier: "controller_company") as! CompanyViewController
                controller.symbol = model.symbol
                self?.navigationController?.pushViewController(controller, animated: true)
            }).disposed(by: disposables)
    }
    
    private func setupSearch() {
        searchBar.rx.text.orEmpty //Filter input from search bar to bind to tableview cells
            .flatMapLatest { [weak self] query -> Observable<[Symbol]> in
                let s = (query.characters.count > 0) ? self?.viewModel.symbols.filter{$0.name.lowercased().contains(query.lowercased())} : self?.viewModel.symbols
                return Observable.from(optional: s)
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] symbols in
                self?.viewModel.updateDataSource(symbols)
            }).disposed(by: disposables)
    }
    
    private func setupReachabilityObserver() {
        viewModel.reachable.observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] reachable in
                if !reachable {
                    self?.showOfflineAlert()
                }
            }).disposed(by: disposables)
    }
    
}
