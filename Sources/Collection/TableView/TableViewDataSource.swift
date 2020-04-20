//
//  TableViewDataSource.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 12/11/19.
//  Copyright © 2019 Undercaffeine. All rights reserved.
//

import Foundation

protocol TableViewDataSourcePrefetching: class {
    func tableViewPrefetch()
}

public class TableViewDataSource: NSObject {
    
    private weak var tableView: UITableView?
    internal weak var delegate: NSObject?
    internal weak var dataSourcePrefetching: TableViewDataSourcePrefetching?
    
    internal var sections: [Section] = []
    private var identifiers: [String: String] = [:]
    
    private var shouldClear: Bool = false
    internal var pageSize: Int = -1
    
    public init(tableView: UITableView, delegate: NSObject? = nil) {
        self.tableView = tableView
        self.delegate = delegate
    }
    
    init(tableView: UITableView, dataSourcePrefetching: TableViewDataSourcePrefetching, delegate: NSObject? = nil) {
        self.tableView = tableView
        self.dataSourcePrefetching = dataSourcePrefetching
        self.delegate = delegate
    }
    
    public func bind<TCell: GenericTableViewCell<TViewModel>, TViewModel: ViewModel>(cell: TCell.Type, to viewModel: TViewModel.Type) {
        self.tableView?.register(UINib(nibName: "\(cell)", bundle: nil), forCellReuseIdentifier: "\(cell)")
        self.identifiers["\(viewModel)"] = "\(cell)"
    }
    
    public func bind<TCell: GenericTableViewCell<TViewModel>, TViewModel: ViewModel>(cell: TCell.Type, to viewModel: TViewModel.Type, forSupplementaryViewOfKind kind: String) {
        self.tableView?.register(UINib(nibName: "\(cell)", bundle: nil), forHeaderFooterViewReuseIdentifier: "\(cell)")
        self.identifiers["\(viewModel)"] = "\(cell)"
    }
    
    public func clear() {
        self.shouldClear = true
    }
    
    public func insert(sections: [Section]) {
        if self.shouldClear || self.sections.isEmpty {
            // clear and reload
            self.sections = sections
            self.shouldClear = false
            self.tableView?.reloadData()
        } else {
            // append to end
            var indexPaths: [IndexPath] = []
            for (xIndex, section) in self.sections.enumerated() {
                for newSection in sections where section.viewModel?.tag == newSection.viewModel?.tag {
                    let currentCount = section.items.count
                    let newCount = newSection.items.count
                    for current in currentCount..<currentCount+newCount {
                        indexPaths.append(IndexPath(row: current, section: xIndex))
                    }
                    section.items.append(contentsOf: newSection.items)
                }
            }
            self.tableView?.beginUpdates()
            self.tableView?.insertRows(at: indexPaths, with: .fade)
            self.tableView?.endUpdates()
            // must check for new sections
        }
        self.tableView?.refreshControl?.endRefreshing()
    }
    
    public func update(sections: [Section]) {
        var indexPaths: [IndexPath] = []
        for (xIndex, section) in self.sections.enumerated() {
            for newSection in sections where section.viewModel?.tag == newSection.viewModel?.tag {
                var items = section.items
                
                for (row, item) in section.items.enumerated() {
                    for item3 in newSection.items where item.tag == item3.tag {
                        items[row] = item3
                        indexPaths.append(IndexPath(row: row, section: xIndex))
                    }
                }
                
                section.items = items
            }
        }
        self.tableView?.beginUpdates()
        self.tableView?.reloadRows(at: indexPaths, with: .automatic)
        self.tableView?.endUpdates()
    }
    
    public func remove(sections: [IndexPath]) {
        for indexPath in sections.sorted().reversed() {
            self.sections[indexPath.section].items.remove(at: indexPath.row)
        }
        self.tableView?.reloadData()
    }
    
}

extension TableViewDataSource: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = self.sections[safe: indexPath.section]?.items[safe: indexPath.row],
            let identifier = self.identifiers[String(describing: type(of: item))] else {
                return UITableViewCell(frame: .zero)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        (cell as? GenericCellProtocol)?.prepare(viewModel: item)
        (cell as? GenericCellDelegateProtocol)?.prepare(indexPath: indexPath, delegate: self.delegate)
        return cell
    }
    
}

extension TableViewDataSource: UITableViewDataSourcePrefetching {
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        // check if we need to prefetch new items
        guard let indexPath = indexPaths.last,
            indexPath.row > self.sections[indexPath.section].items.count - self.pageSize else {
                return
        }
        self.dataSourcePrefetching?.tableViewPrefetch()
    }
    
}
