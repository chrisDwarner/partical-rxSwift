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

        tableView.dataSource = self
        refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                    // filter out the meta data, we only want the devices.
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
            .subscribe(onNext:{ [weak self] newBoxes in
                self?.processEvents(newBoxes)
            })
            .addDisposableTo(disposeBag)
    }

    func processEvents(_ newBoxes: [BoxDocument]) {
        let updatedBoxes = newBoxes + BoxDocuments.instance.boxes.value
        BoxDocuments.instance.boxes.value = updatedBoxes
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - Table Data Source
extension BoxesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BoxDocuments.instance.boxes.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = BoxDocuments.instance.boxes.value[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "BoxCellId") as! BoxDocTableViewCell
        cell.configureWithBox(boxDocument: event)
        return cell as UITableViewCell
    }
}

