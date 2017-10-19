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

class CompanyListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let disposables = DisposeBag()
    let service = IexService()
    let dataSource = RxTableViewSectionedReloadDataSource<SymbolSection>()
    let symbolsObservable = Variable<[SymbolSection]>([SymbolSection]())
    var symbols = [Symbol]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupDataSource()
        setupObservables()
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
        setupSearch()
        
        symbolsObservable.asObservable().observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposables)
        
        service.getSymbols().observeOn(MainScheduler.instance)
            .map { $0.filter { $0.name.characters.count > 0 && $0.isEnabled } }
            .subscribe(onNext: { [weak self] symbols in
                self?.symbols = symbols
                self?.symbolsObservable.value = [SymbolSection(items: symbols)]
            }).disposed(by: disposables)
        
        tableView.rx.modelSelected(Symbol.self).observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] model in
                
            }).disposed(by: disposables)
    }
    
    private func setupSearch() {
        searchBar.rx.text.orEmpty //Filter input from search bar to bind to tableview cells
            .flatMapLatest { [weak self] query -> Observable<[Symbol]> in
                let s = (query.characters.count > 0) ? self?.symbols.filter{$0.name.lowercased().contains(query.lowercased())} : self?.symbols
                return Observable.from(optional: s)
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] symbols in
                self?.symbolsObservable.value = [SymbolSection(items: symbols)]
            }).disposed(by: disposables)
    }
    
}
