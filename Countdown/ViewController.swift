//
//  ViewController.swift
//  Countdown
//
//  Created by Oğuzcan Beşerikli on 2.05.2024.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    var tableView = UITableView()
    var alertController: UIAlertController?
    let refreshControl = UIRefreshControl()
    var events = [Reminder]()
    var representationData = [Reminder]()
    let segmentControl = SegmentControl(items: ["Future Events", "Past Events"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        getAuthForNotification()
        configureNavigationBar()
        configureSegment()
        configureTableView()
        configurePullToRefresh()
        events = PersistentManager.shared.readData()
        seperateEvents()
        tableView.reloadData()
    }
    
    func configureNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(handleBarButtonAction))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editAction))
        self.navigationItem.title = "Events"
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 65
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ViewCell.self, forCellReuseIdentifier: "cell")
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor)
        ])
    }
    
    func addEvent() {
        let viewController = AddEventViewController()
        viewController.delegate = self
        present(viewController, animated: true)
    }
    
    @objc func handleBarButtonAction() {
        addEvent()
    }
    
    @objc func editAction() {
        self.tableView.isEditing = !self.tableView.isEditing
        title = (self.tableView.isEditing) ? "Editing" : "Events"
    }
    
    func configurePullToRefresh() {
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc func refresh(_ sender: AnyObject) {
        events = PersistentManager.shared.readData()
        seperateEvents()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func configureSegment() {
        view.addSubview(segmentControl)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.addTarget(self, action: #selector(didValueChanged), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentControl.widthAnchor.constraint(equalToConstant: 375)
        ])
    }
    
    func seperateEvents() {
        representationData.removeAll()
        switch segmentControl.selectedSegmentIndex {
        case 0: // Future Events
            for event in events {
                if event.date > Date.now {
                    representationData.append(event)
                }
            }
            tableView.reloadData()
        case 1: // Past Events
            for event in events {
                if event.date < Date.now {
                    representationData.append(event)
                }
            }
            tableView.reloadData()
        default:
            break
        }
    }
    
    @objc func didValueChanged() {
        seperateEvents()
    }
    
    func getAuthForNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
    }
    
    func scheduleNotification(reminder: Reminder) {
        let content = UNMutableNotificationContent()
        content.title = "Countdown Ended!"
        content.body = "Your countdown \(reminder.title) has ended."
        content.sound = UNNotificationSound.default
        
        // Set the trigger to deliver the notification immediately
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: reminder.date.timeIntervalSinceNow, repeats: false)
        
        // Create the request
        let request = UNNotificationRequest(identifier: reminder.id, content: content, trigger: trigger)
        
        // Add the request to the notification center
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
}

extension ViewController: AddEventViewDelegate {
    func addEventTapped(eventTitle: String, eventDate: Date) {
        let reminder = Reminder(id: UUID().uuidString, title: eventTitle, date: eventDate)
        events.append(reminder)
        PersistentManager.shared.saveData(data: events)
        events = PersistentManager.shared.readData()
        seperateEvents()
        scheduleNotification(reminder: reminder)
    }
}

extension ViewController: DetailViewDelegate {
    func saveButtonTapped(editedReminder: Reminder) {
        var savedReminders = PersistentManager.shared.readData()
        guard let reminderToEditIndex = savedReminders.firstIndex(where: { $0.id == editedReminder.id }) else { return }
        savedReminders[reminderToEditIndex] = editedReminder
        PersistentManager.shared.saveData(data: savedReminders)
        events = PersistentManager.shared.readData()
        seperateEvents()
        scheduleNotification(reminder: editedReminder)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return representationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewCell
        cell.set(reminder: representationData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedReminder = representationData[indexPath.row]
        let vc = DetailViewController(selectedReminder: selectedReminder, delegate: self)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Remove the item from the source index path
        let movedObj = representationData.remove(at: sourceIndexPath.row)
        
        // Insert the item at the destination index path
        representationData.insert(movedObj, at: destinationIndexPath.row)
        PersistentManager.shared.saveData(data: events)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let deletedEvent = representationData.remove(at: indexPath.row)
            events.removeAll { reminder in
                reminder.id == deletedEvent.id
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            PersistentManager.shared.saveData(data: events)
        }
    }
}

