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

    let api = "/box"
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated )
        refresh()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func configureTableView() {
        BoxDocuments.instance.boxes.asObservable().bindTo(tableView.rx.items(cellIdentifier: "BoxCellId", cellType: BoxDocTableViewCell.self)) { (row, box, cell) in
            cell.configureWithBox(boxDocument: box)
            }
            .addDisposableTo(disposeBag)
    }

    func refresh() {
       _ = Observable.from([api])
        .map { urlString -> URL in return URL(string: "https://virtserver.swaggerhub.com/particle-iot/box/0.1\(self.api)?per_page=10")! }
            .map { url -> URLRequest in
                var request:URLRequest = URLRequest(url: url)
                request.addValue("application/json", forHTTPHeaderField: "accept")
                request.addValue("Bearer mytoken123", forHTTPHeaderField: "Authorization")
                return request }
            .flatMap { request -> Observable<(HTTPURLResponse, Data)> in return URLSession.shared.rx.response(request: request) }
            .shareReplay(1)
            .map { http, data -> [[String: Any]] in
                if 200 ..< 300 ~= http.statusCode {

                    guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                          let result = jsonObject as? [String: Any] else {
                            return []
                    }
                    // filter out the meta data, we only want the device list.
                    guard let payload = result["data"] as? [[String:Any]] else {
                        return []
                    }
                    return payload
                }
                else {
                    print(http.statusCode)
                }
                return []
            }
            .filter { objects in
                return objects.count > 0
            }
            .map{ objects in
                return objects.map(BoxDocument.init)
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{ [weak self] newBoxes in
                self?.processEvents(newBoxes)
            })
            .addDisposableTo(disposeBag)
    }

    func processEvents(_ newBoxes: [BoxDocument]) {
        BoxDocuments.instance.boxes.value = newBoxes

        BoxDocuments.instance.boxes.asObservable().subscribe({ e in

        })
            .addDisposableTo(disposeBag)
    }
}
