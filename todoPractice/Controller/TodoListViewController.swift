//
//  ViewController.swift
//  todoPractice
//
//  Created by user on 2022/06/05.
//

import UIKit
import CoreLocation
import FirebaseAuth

class TodoListViewController: UITableViewController
{
    
    var dataModel:DataModel?
    let locationManager:CLLocationManager = CLLocationManager()
    
    @IBOutlet weak var authButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var handle: AuthStateDidChangeListenerHandle?
    var itemArray = [Item]()
    var cityNameArray = [String]()
    var weatherManager = WeatherManager()
    var loginStatus:Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled(){
            locationManager.allowsBackgroundLocationUpdates = false
            locationManager.distanceFilter = 1000
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
        }
        
        weatherManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let user = Auth.auth().currentUser
        if user != nil {
            dataModel = DataModel(userId: user!.uid)
            loginStatus = true
            authButton.title = "SignOut"
            self.dataModel!.loadData().forEach { item in
                if !itemArray.contains(item){
                    itemArray.append(item)
                }
            }
            self.tableView.reloadData()
        } else {
            loginStatus = false
            authButton.title = "Login"
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as! ToDoItemCell
        let currentItem = itemArray[indexPath.row]
        
        cell.cellImage.image = UIImage(systemName: currentItem.weather)
        cell.temperature.text = currentItem.temperature
        cell.city.text = currentItem.city
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.row == 0 {
            return nil
        }
        
        
        let deleteAction = UIContextualAction(style: .destructive, title:"delete") {
            (ctxAction, view, completionHandler) in
            
            self.itemArray.remove(at: indexPath.row)
            self.dataModel?.saveData(self.itemArray)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            completionHandler(true)
        }
        
        
        let trashImage = UIImage(systemName: "trash.fill")?.withTintColor(UIColor.white , renderingMode: .alwaysTemplate)
        deleteAction.image = trashImage
        deleteAction.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        
        let swipeAction = UISwipeActionsConfiguration(actions:[deleteAction])
        swipeAction.performsFirstActionWithFullSwipe = false
        
        
        
        return swipeAction
    }
    
    
    @IBAction func authButtonPressed(_ sender: UIBarButtonItem) {
        if loginStatus == true {
        do {
          try Auth.auth().signOut()
            authButton.title = "Login"
            self.itemArray = [itemArray[0]]
            self.tableView.reloadData()
            loginStatus = false
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
        }else{
            performSegue(withIdentifier: "GotoLogin", sender: nil)
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "都市名を追加できます。", message: nil, preferredStyle: .alert)
        let action:UIAlertAction
        
        if loginStatus == true {
            action = UIAlertAction(title: "追加", style: .default) { (action) in
                
                if let text = textField.text {
                    self.weatherManager.fetchWeather(cityName: text)
                }
            }
            
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "英語で入力してください。"
                textField = alertTextField
            }
            
        }else{
            
            alert.title = "loginしてください。"
            action = UIAlertAction(title: "OK", style: .default, handler:nil)
        
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}


extension TodoListViewController: WeatherManagerDelegate{
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        let user = Auth.auth().currentUser
        var existItem = false
        let currentItem = Item(weather: weather.getConditionName, city: weather.cityName, temperature: String(weather.temperature))
        
        itemArray.forEach { item in
            if item == currentItem{
                existItem = true
            }
        }
        
        if existItem == true {
            return
        }
        
        DispatchQueue.main.async {
            self.itemArray.append(currentItem)
            if self.loginStatus == true {
                self.dataModel!.saveData(self.itemArray)
            }
            self.tableView.reloadData()
        }
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


extension TodoListViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        settingOfLocation(locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationError", error)
    }
    
    func settingOfLocation(_ locations:[CLLocation]){
        if let locationData = locations.last {
            let lat = locationData.coordinate.latitude
            let lon = locationData.coordinate.longitude
            
            let location = CLLocation(latitude: lat, longitude:lon)
            CLGeocoder().reverseGeocodeLocation(location) { place, err in
                if err != nil {
                    print(err!)
                    return
                }
                let currentCity = place?.first?.city ?? "Tokyo"
                self.weatherManager.fetchWeather(cityName: currentCity)
            }
        }
    }
}
