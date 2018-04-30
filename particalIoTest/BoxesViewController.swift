//
//  BoxesViewController.swift
//  particalIoTest
//
//  Created by chris warner on 4/29/18.
//  Copyright © 2018 chris warner. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class BoxesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createNewBoxButton: UIBarButtonItem!

    let boxDocuments = Observable.just(BoxDocument.testData)
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCells()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func setupCells() {
        boxDocuments.bind(to: tableView.rx.items(cellIdentifier:"BoxCellId", cellType:BoxDocTableViewCell.self)) {
            row, box, cell in
            cell.configureWithBox(boxDocument: box)
        }
        .disposed(by: disposeBag)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
