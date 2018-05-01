//
//  ViewController.swift
//  particalIoTest
//
//  Created by chris warner on 4/28/18.
//  Copyright © 2018 chris warner. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var keyTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var scopeTextField: UITextField!
    @IBOutlet weak var deviceIdTextField: UITextField!
    @IBOutlet weak var productIdTextField: UITextField!
    @IBOutlet weak var updatedTextField: UITextField!
    @IBOutlet weak var deleteButton: UIBarButtonItem!

    var keyName:String? = nil
    var boxModel:BoxDocument? = nil
    let api = "/box"
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()


        if let boxModel = boxModel {
            keyTextField.rx.text.orEmpty.bindTo(boxModel.key).addDisposableTo(disposeBag)
            valueTextField.rx.text.orEmpty.bindTo(boxModel.value).addDisposableTo(disposeBag)
            scopeTextField.rx.text.orEmpty.bindTo(boxModel.scope).addDisposableTo(disposeBag)
            deviceIdTextField.rx.text.orEmpty.bindTo(boxModel.device_id).addDisposableTo(disposeBag)
            productIdTextField.rx.text.orEmpty.map{ text -> Int in return Int(text) ?? 0 }.bindTo(boxModel.product_id).addDisposableTo(disposeBag)
            updatedTextField.rx.text.orEmpty.bindTo(boxModel.updated_at).addDisposableTo(disposeBag)


            self.deleteButton.rx.tap.asObservable().subscribe(onNext: { self.serverRequest("DELETE") }).addDisposableTo(disposeBag)

            fetchBox()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func alert(title: String, text: String?) -> Observable<Void> {
        return Observable.create { [weak self] observer in
            let alertVC = UIAlertController(title: title, message: text, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                observer.onCompleted()
            }))

            self?.present(alertVC, animated: true, completion: nil)
            return Disposables.create {
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }

    private func fetchBox() {
        _ = Observable.from([api])
            .map { urlString -> URL in return URL(string: "https://virtserver.swaggerhub.com/particle-iot/box/0.1\(self.api)/\(self.keyName ?? "")")! }
            .map { url -> URLRequest in
                var request:URLRequest = URLRequest(url: url)
                request.addValue("application/json", forHTTPHeaderField: "accept")
                request.addValue("Bearer mytoken123", forHTTPHeaderField: "Authorization")
                return request }
            .flatMap { request -> Observable<(HTTPURLResponse, Data)> in return URLSession.shared.rx.response(request: request) }
            .shareReplay(1)
            .map { http, data -> BoxDocument in
                if 200 ..< 300 ~= http.statusCode {

                    guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                        let result = jsonObject as? [String: Any] else {
                            return BoxDocument(dictionary: [:])
                    }

                    return BoxDocument(dictionary: result)
                }
                else {
                    print(http.statusCode)
                }
                return BoxDocument(dictionary: [:])
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { newBoxes in
                self.boxModel = newBoxes
                if let boxModel = self.boxModel {
                    self.keyTextField.text = boxModel.key.value
                    self.valueTextField.text = boxModel.value.value
                    self.scopeTextField.text = boxModel.scope.value
                    self.deviceIdTextField.text = boxModel.device_id.value
                    self.productIdTextField.text = String(boxModel.product_id.value)
                    self.updatedTextField.text = boxModel.updated_at.value
                }
            })
            .addDisposableTo(disposeBag)
    }

    private func serverRequest(_ httpMethod: String) {

        if let boxModel = self.boxModel {
            let key = boxModel.key.value

            _ = Observable.from([api])
                .map { urlString -> URL in return URL(string: "https://virtserver.swaggerhub.com/particle-iot/box/0.1\(self.api)/\(key)")! }
                .map { url -> URLRequest in
                    var request:URLRequest = URLRequest(url: url)
                    request.addValue("Bearer mytoken123", forHTTPHeaderField: "Authorization")
                    request.httpMethod = httpMethod
                    return request }
                .flatMap { request -> Observable<(HTTPURLResponse, Data)> in return URLSession.shared.rx.response(request: request)}
                .shareReplay(1)
                .map { httpResponse, _ -> Bool in
                    if 200 ..< 300 ~= httpResponse.statusCode {
                        return true
                    }
                    else {
                        print(httpResponse.statusCode)
                    }
                    return false
                }
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { result in

                    var message:String?
                    var title:String = "Box"

                    if httpMethod == "DELETE" {
                        title = "Delete Box"
                    }

                    if result {
                        message = "Success!"
                    }
                    else {
                        if httpMethod == "DELETE" {
                            message = "failed to delete Box"
                        }
                        else {
                            message = "failed to fetch Box"
                        }
                    }
                    self.alert(title: title, text: message)
                        .take(5.0, scheduler: MainScheduler.instance)
                        .subscribe(onDisposed: { [weak self] in
                            self?.dismiss(animated: true, completion: nil)
                            _ = self?.navigationController?.popViewController(animated: true)
                        })
                        .addDisposableTo(self.disposeBag)
                })
                .addDisposableTo(disposeBag)
        }
    }
}

