//
//  File.swift
//  TestScreen
//
//  Created by G on 09.02.2023.
//
import UIKit

class MainViewController: UIViewController {
    
    private let nc = NotificationCenter.default
    
    let imagePicker = UIImagePickerController()
    var tempImage: UIImageView?
    var person = PersonModel()
    
    private lazy var tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.dataSource = self
        //$0.keyboardDismissMode = .onDrag
        $0.register(AvatarViewCell.self, forCellReuseIdentifier: "AvatarCell")
        $0.register(PersonDetailesCell.self, forCellReuseIdentifier: "DetailCell")
        return $0
    }(UITableView(frame: .zero, style: .grouped))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.view.backgroundColor = .white
        imagePicker.delegate = self
    }
      
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(pushDoneVC))
        if !person.isCompeted {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        navigationItem.backButtonTitle = "Назад"
        nc.addObserver(self, selector: #selector(kbdShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(kbdHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        addTapGestureToHideKeyboard()
    }
    
    @objc private func pushDoneVC() {
        guard let name = person.name, let surname = person.surname, let lastName = person.lastName else {return}
        let message = "Спасибо за регистрацию,\n\(surname) \(name) \(lastName)"
        let vc = DoneViewController(image: person.image, message: message)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func kbdShow(notification: NSNotification) {
        if let kbdSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset.bottom = kbdSize.height
            tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbdSize.height, right: 0)
        }
    }

    @objc private func kbdHide() {
        tableView.contentInset = .zero
        tableView.verticalScrollIndicatorInsets = .zero
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        nc.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    func setupView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }
}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return mainViewControllerData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AvatarCell", for: indexPath) as! AvatarViewCell
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! PersonDetailesCell
        cell.selectionStyle = .none
        if indexPath.row == 3 {
            cell.setupCell(detail: mainViewControllerData[indexPath.row], number: true)
        } else {
            cell.setupCell(detail: mainViewControllerData[indexPath.row], number: false)
        }
        cell.setupDelegate(delegate: self)
        return cell
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.placeholder {
        case "Фамилия":
            let nextCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! PersonDetailesCell
            nextCell.detailTextField.becomeFirstResponder()
        case "Имя":
            let nextCell = tableView.cellForRow(at: IndexPath(row: 2, section: 1)) as! PersonDetailesCell
            nextCell.detailTextField.becomeFirstResponder()
        case "Отчество":
            let nextCell = tableView.cellForRow(at: IndexPath(row: 3, section: 1)) as! PersonDetailesCell
            nextCell.detailTextField.becomeFirstResponder()
        case "Возраст":
            view.endEditing(true)
        default:
            break
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)  {
        guard var text = textField.text else { return }
        text.removeAll(where: {$0 == " " })
        switch textField.placeholder {
        case "Фамилия":
            if !text.isEmpty {person.surname = text} else {person.surname = nil}
        case "Имя":
            if !text.isEmpty {person.name = text} else {person.name = nil}
        case "Отчество":
            if !text.isEmpty {person.lastName = text} else {person.lastName = nil}
        case "Возраст":
            if !text.isEmpty {
                if let age = Int(text) {
                    person.age = age
                }
            }  else {person.age = nil}
        default:
            break
        }
        if person.isCompeted {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard var text = textField.text else { return true }
        if range.length == 0 {text += string} else {text.removeLast()}
        text.removeAll(where: {$0 == " " })
        switch textField.placeholder {
        case "Фамилия":
            if !text.isEmpty {person.surname = text} else {person.surname = nil}
        case "Имя":
            if !text.isEmpty {person.name = text} else {person.name = nil}
        case "Отчество":
            if !text.isEmpty {person.lastName = text} else {person.lastName = nil}
        case "Возраст":
            if !text.isEmpty {
                if let age = Int(text) {
                    person.age = age
                }
            }  else {person.age = nil}
        default:
            return true
        }
        if person.isCompeted {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        guard textField.placeholder == "Возраст" else { return true }
        let currentCharacterCount = textField.text?.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        if newLength <= 2 {
            return true
        }
        text.removeLast()
        if let age = Int(text) {
            person.age = age
        }
        return false
    }
}

extension MainViewController: UploadImageDelegate {
    func uploadImage(image: UIImageView) {
        tempImage = image
        let alert = UIAlertController(title: "Загрузить фото:", message: nil, preferredStyle: .actionSheet)
        let actionPhoto = UIAlertAction(title: "Из фотогaлереи", style: .default) { (alert) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true)
        }
        let actionCamera = UIAlertAction(title: "Сделать фото", style: .default) { (alert) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true)
        }
        let actionCancel  = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(actionPhoto)
        alert.addAction(actionCamera)
        alert.addAction(actionCancel)
        present(alert, animated: true)
    }
}
 
extension MainViewController:  UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            tempImage?.image = pickedImage
            person.image = pickedImage
        }
        dismiss(animated: true)
    }
}
