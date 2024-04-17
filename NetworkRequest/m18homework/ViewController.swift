//
//  ViewController.swift
//  m18homework
//
//  Created by Владислав on 12.04.2024.
//

import UIKit
import SnapKit
import Alamofire

class ViewController: UIViewController {
    
    //MARK: Создание элементов UI
    
    var result: String?
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.placeholder = " Введите запрос "
        textField.backgroundColor = .systemGray6
        textField.layer.borderColor = UIColor.black.cgColor
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowRadius = 7
        return textField
    }()
    
    private lazy var buttonSession: UIButton = {
        let button = UIButton()
        button.setTitle("URLSession", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 15
        button.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
        button.addTarget(self, action: #selector(onButtonSessionTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonAlamofire: UIButton = {
        let button = UIButton()
        button.setTitle("Alamofire", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 15
        button.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
        button.addTarget(self, action: #selector(onButtonAlamofireTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackWithButtons: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(buttonSession)
        stack.addArrangedSubview(buttonAlamofire)
        stack.axis = .horizontal
        stack.spacing = 40
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private lazy var responseTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = true
        textView.isEditable = false
        textView.text = " Результат "
        
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .black
        textView.backgroundColor = .systemGray6
        textView.layer.cornerRadius = 20
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.cgColor
        
        return textView
    }()
    
    
    
    // MARK: Реализация действия кнопок
    
    @objc func onButtonSessionTapped() {
        guard let requestText = textField.text else {
            return
        }
        
        let urlString = URL(string: "https://kinopoiskapiunofficial.tech/api/v2.1/films/search-by-keyword?keyword=\(requestText)")!
        
        var request = URLRequest(url: urlString)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["X-API-KEY": "138d8397-4514-4a1c-8323-90a826b5efa0"]
        request.httpBody = nil
        

        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error{
                print(error)
                DispatchQueue.main.async {[weak self] in
                    guard let self = self else {return}
                    result = "Ошибка"
                    self.responseTextView.text = result
                    
                }
            } else {
                print(response ?? "Нет ответа")
                if let data = data {
                    DispatchQueue.main.async {[weak self] in
                        guard let self = self else {return}
                        result = String(data: data, encoding: .utf8) ?? "Что-то не так"
                        self.responseTextView.text = result
                    }
                }
            }
        }
        task.resume()
    }

    
    @objc func onButtonAlamofireTapped() {
        
        guard let requestText = textField.text else {
            return
        }
        
        let url = "https://kinopoiskapiunofficial.tech/api/v2.1/films/search-by-keyword?keyword=\(requestText)"
        let headers:HTTPHeaders = ["X-API-KEY": "138d8397-4514-4a1c-8323-90a826b5efa0"]
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                if let error = response.error{
                    print(error)
                    DispatchQueue.main.async {[weak self] in
                        guard let self = self else {return}
                        result = "Ошибка"
                        self.responseTextView.text = result
                    }
                } else {
                    
                    if let data = response.data {
                        DispatchQueue.main.async {[weak self] in
                            guard let self = self else {return}
                            result = String(data: response.data!, encoding: .utf8) ?? "Что-то не так"
                            self.responseTextView.text = result
                        }
                    }
                }
            }
    }
    
    
    //MARK: Расположение элементов на экране

    private func setupViews() {
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(40)
        }
        
        view.addSubview(stackWithButtons)
        stackWithButtons.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottomMargin).offset(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(70)

        }
        
        view.addSubview(responseTextView)
        responseTextView.snp.makeConstraints { make in
            make.top.equalTo(stackWithButtons.snp.bottomMargin).offset(50)
            make.bottom.equalToSuperview().offset(50)

            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            
        }
    }
    
    
    // MARK: Запуск
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

