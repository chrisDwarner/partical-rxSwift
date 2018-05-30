//
//  NewBoxViewController.swift
//  particalIoTest
//
//  Created by chris warner on 4/30/18.
//  Copyright © 2018 chris warner. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class NewBoxViewController: UIViewController {
    @IBOutlet weak var key: UITextField!
    @IBOutlet weak var value: UITextField!
    @IBOutlet weak var scope: UITextField!
    @IBOutlet weak var device: UITextField!
    @IBOutlet weak var product: UITextField!
    @IBOutlet weak var updated: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!

    let api = "/box"
    let boxModel = BoxDocument(dictionary: [:])
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true

        key.rx.text.orEmpty.bind(to: boxModel.key).disposed(by: disposeBag)
        value.rx.text.orEmpty.bind(to: boxModel.value).disposed(by: disposeBag)
        scope.rx.text.orEmpty.bind(to: boxModel.scope).disposed(by: disposeBag)
        device.rx.text.orEmpty.bind(to: boxModel.device_id).disposed(by: disposeBag)
        product.rx.text.orEmpty.map{ text -> Int in return Int(text) ?? 0 }.bind(to: boxModel.product_id).disposed(by: disposeBag)
        updated.rx.text.orEmpty.bind(to: boxModel.updated_at).disposed(by: disposeBag)

        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)

        updated.text = dateString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func confirmButtonValid(key: Observable<String>, device: Observable<String>) -> Observable<Bool> {
        return Observable.combineLatest(key, device)
        { (key, device) in
            return key.count > 0
                && device.count > 0
        }
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

    @IBAction func cancelAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func addAction(_ sender: Any) {

        _ = Observable.from([api])
            .map { urlString -> URL in return URL(string: "https://virtserver.swaggerhub.com/particle-iot/box/0.1\(self.api)")! }
            .map { url -> URLRequest in
                var request:URLRequest = URLRequest(url: url)
                request.addValue("application/json", forHTTPHeaderField: "accept")
                request.addValue("Bearer mytoken123", forHTTPHeaderField: "Authorization")
                request.httpMethod = "POST"

                do {
                    let payload = self.boxModel.dictionary
                    let json = try JSONSerialization.data(withJSONObject: payload, options: .prettyPrinted)
                    request.httpBody = json
                }
                catch {
                    print(error.localizedDescription)
                }

                return request }
            .flatMap { request -> Observable<(response: HTTPURLResponse, data: Data)> in return URLSession.shared.rx.response(request: request)}
            .share(replay: 1)
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

                if result {
                    message = "Success!"
                }
                else {
                    message = "failed to create Box"
                }
                self.alert(title: "New Box", text: message)
                    .take(5.0, scheduler: MainScheduler.instance)
                    .subscribe(onDisposed: { [weak self] in
                        self?.dismiss(animated: true, completion: nil)
                        _ = self?.navigationController?.popViewController(animated: true)
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)

        navigationController?.popViewController(animated: true)
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
