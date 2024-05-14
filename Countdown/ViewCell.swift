//
//  ViewCell.swift
//  Countdown
//
//  Created by Oğuzcan Beşerikli on 2.05.2024.
//

import UIKit

class ViewCell: UITableViewCell {
    
    let titleLabel = UILabel()
    let remainingDaysLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemBackground
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(reminder: Reminder) {
        titleLabel.text = reminder.title
        let remainingDays = calculateCountdownDays(from: reminder.date)
        remainingDaysLabel.text = remainingDays
    }
    
    func configure() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
        ])
        
        remainingDaysLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(remainingDaysLabel)
        
        NSLayoutConstraint.activate([
            remainingDaysLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            remainingDaysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            remainingDaysLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    func calculateCountdownDays(from date: Date) -> String {
        let calendar = Calendar.current
        let currentDate = Date()
        
        // Calculate difference in days
        let components = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: date)
        guard
            let day = components.day,
            let hour = components.hour,
            let minute = components.minute
             else {
            return "None"
        }
        if date > currentDate {
            return "Countdown: \(day) day, \(hour) hour, \(minute) min"
        }
        else {
            return date.formatted()
        }
    }
}
