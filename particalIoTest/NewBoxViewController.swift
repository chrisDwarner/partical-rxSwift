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

    let boxModel = BoxDocument(dictionary: [:])
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        key.rx.text.orEmpty.bindTo(boxModel.key).addDisposableTo(disposeBag)
        value.rx.text.orEmpty.bindTo(boxModel.value).addDisposableTo(disposeBag)
        scope.rx.text.orEmpty.bindTo(boxModel.scope).addDisposableTo(disposeBag)
        device.rx.text.orEmpty.bindTo(boxModel.device_id).addDisposableTo(disposeBag)
//        product.rx.text.map{ return Int($0!)! }.bindTo(boxModel.product_id).addDisposableTo(disposeBag)
        updated.rx.text.orEmpty.bindTo(boxModel.updated_at).addDisposableTo(disposeBag)

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
            return key.characters.count > 0
                && device.characters.count > 0
        }
    }

    @IBAction func cancelAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func addAction(_ sender: Any) {
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
