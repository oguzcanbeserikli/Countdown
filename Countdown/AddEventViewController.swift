//
//  AddEventViewController.swift
//  Countdown
//
//  Created by Oğuzcan Beşerikli on 4.05.2024.
//

import UIKit

class AddEventViewController: UIViewController {
    private let eventNameTextField = UITextField()
    private let addButton = UIButton()
    private let datePicker = UIDatePicker()
    private let addEventTitle = UILabel()
    var delegate: AddEventViewDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureAddEventTitle()
        configureEventNameTextField()
        configureDatePicker()
        configureAddButton()
    }
    
    private func configureAddEventTitle() {
        view.addSubview(addEventTitle)
        addEventTitle.translatesAutoresizingMaskIntoConstraints = false
        addEventTitle.text = "Add Event"
        addEventTitle.font = UIFont.boldSystemFont(ofSize: 20.0)
        
        NSLayoutConstraint.activate([
            addEventTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            addEventTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func configureEventNameTextField() {
        eventNameTextField.placeholder = "Event name"
        eventNameTextField.translatesAutoresizingMaskIntoConstraints = false
        eventNameTextField.backgroundColor = .secondarySystemBackground
        eventNameTextField.layer.cornerRadius = 10
        view.addSubview(eventNameTextField)
        
        NSLayoutConstraint.activate([
            eventNameTextField.topAnchor.constraint(equalTo: addEventTitle.bottomAnchor, constant: 20),
            eventNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            eventNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            eventNameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureDatePicker() {
        datePicker.minimumDate = .now
        datePicker.preferredDatePickerStyle = .inline
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: eventNameTextField.bottomAnchor, constant: 30),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
    }
    
    private func configureAddButton() {
        addButton.setTitle("Add", for: .normal)
        addButton.backgroundColor = .systemBlue
        addButton.layer.cornerRadius = 10
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 30),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            addButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func addButtonTapped() {
        guard let eventTitle = eventNameTextField.text, !eventTitle.isEmpty else {
            print("Text field is empty.")
            return
        }
        
        delegate?.addEventTapped(eventTitle: eventTitle, eventDate: datePicker.date)
        dismiss(animated: true)
    }
}

protocol AddEventViewDelegate {
    func addEventTapped(eventTitle: String, eventDate: Date)
}


