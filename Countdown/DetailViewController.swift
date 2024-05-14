//
//  DetailViewController.swift
//  Countdown
//
//  Created by Oğuzcan Beşerikli on 9.05.2024.
//

import UIKit

class DetailViewController: UIViewController {
    var selectedReminder: Reminder
    var delegate: DetailViewDelegate?
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    let countdownLabel = UILabel()
    let saveButton = UIButton()
    let datePicker = UIDatePicker()
    let memoryTextField = UITextView()
    let characterLimitLabel = UILabel()
    
    init(selectedReminder: Reminder, delegate: DetailViewDelegate?) {
        self.selectedReminder = selectedReminder
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.navigationItem.title = "Event Details"
        configure(reminder: selectedReminder)
        seperateDetail()
        configureSaveButton()
    }
    
    private func configure(reminder: Reminder) {
        view.addSubview(titleLabel)
        titleLabel.text = reminder.title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 19, weight: .semibold)
        titleLabel.lineBreakMode = .byWordWrapping
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let dateString = dateFormatter.string(from: reminder.date)
        dateLabel.text = dateString
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(countdownLabel)
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        countdownLabel.text = calculateCountdownDays(from: reminder.date)
        countdownLabel.lineBreakMode = .byWordWrapping
        countdownLabel.numberOfLines = 0
        countdownLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            countdownLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 30),
            countdownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            countdownLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            countdownLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
    }
    
    private func calculateCountdownDays(from date: Date) -> String {
        let calendar = Calendar.current
        let currentDate = Date()
        
        // Calculate difference in days
        let components = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: date)
        guard
            let day = components.day,
            let hour = components.hour,
            let minute = components.minute,
            let second = components.second else {
            return "None"
        }
        if date > currentDate {
            return "Time remaining  \n  \(day) day, \(hour) hour, \(minute) min, \(second) sec"
        }
        else {
            return ""
        }
    }
    
    private func configureDatePicker() {
        datePicker.date = selectedReminder.date
        datePicker.minimumDate = .now
        datePicker.preferredDatePickerStyle = .inline
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: countdownLabel.bottomAnchor, constant: 30),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    private func configureMemoryTextField() {
        memoryTextField.text = (selectedReminder.memoryText != nil) ? selectedReminder.memoryText : "Write memory here."
        memoryTextField.textColor = UIColor.lightGray
        memoryTextField.font = .systemFont(ofSize: 16)
        memoryTextField.backgroundColor = .secondarySystemBackground
        memoryTextField.layer.cornerRadius = 10
        memoryTextField.textAlignment = .left
        memoryTextField.autocorrectionType = .no
        memoryTextField.delegate = self
        
        memoryTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(memoryTextField)
        
        NSLayoutConstraint.activate([
            memoryTextField.topAnchor.constraint(equalTo: countdownLabel.bottomAnchor, constant: 30),
            memoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            memoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            memoryTextField.heightAnchor.constraint(equalToConstant: 275)
        ])
        
        characterLimitLabel.text = "500 characters remaining"
        characterLimitLabel.textColor = .gray
        characterLimitLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(characterLimitLabel)
        
        NSLayoutConstraint.activate([
            characterLimitLabel.topAnchor.constraint(equalTo: memoryTextField.bottomAnchor, constant: 8),
            characterLimitLabel.leadingAnchor.constraint(equalTo: memoryTextField.leadingAnchor),
            characterLimitLabel.trailingAnchor.constraint(equalTo: memoryTextField.trailingAnchor)
        ])
    }
    
    private func seperateDetail() {
        let currentDate = Date()
        let date = selectedReminder.date
        
        if date > currentDate {
            configureDatePicker()
        }
        else {
            configureMemoryTextField()
        }
    }
    
    private func configureSaveButton() {
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.layer.cornerRadius = 10
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func saveButtonTapped() {
        let editedReminder = Reminder(
            id: selectedReminder.id,
            title: selectedReminder.title,
            memoryText: memoryTextField.text,
            date: selectedReminder.date < .now ? selectedReminder.date : datePicker.date
        )
        delegate?.saveButtonTapped(editedReminder: editedReminder)
        navigationController?.popViewController(animated: true)
    }
}

extension DetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray && textView.text == "Write memory here." {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let text = textView.text,
              text.count + text.count - range.length <= 500 else {
            return false
        }
        let remainingCharacters = 500 - (text.count + text.count - range.length)
        characterLimitLabel.text = "\(remainingCharacters) characters remaining"
        return true
    }
}

protocol DetailViewDelegate {
    func saveButtonTapped(editedReminder: Reminder)
}


