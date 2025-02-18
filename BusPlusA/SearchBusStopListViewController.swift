//
//  SearchBusStopListViewController.swift
//  BusPlusA
//
//  Created by iui on 2019/12/8.
//  Copyright © 2019 Carolyn Yu. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SearchBusStopCell:UITableViewCell {
    @IBOutlet weak var searchBusStopBgImg: UIImageView!
    @IBOutlet weak var searchBusStopNameLabel: UILabel!
    @IBOutlet weak var searchBusStopTimeLabel: UILabel!
    @IBOutlet weak var searchBusStopBookLabel: UILabel!
}

class SearchBusStopListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var nowLabel: UILabel!
    @IBOutlet weak var nowDirectionLabel: UILabel!
    @IBOutlet weak var changeDirectionBtn: UIButton!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var changeDirectionLabel: UILabel!
    
    @IBOutlet weak var stopsListView: UITableView!
    
    let stopsList = ["南港高工(重陽)", "潭美公園", "南京舊宗路口", "麥帥一橋", "南京公寓(捷運南京三民站)", "南京三民路口", "南京寧安街口", "南京敦化路口(小巨蛋)", "捷運南京復興站", "南京龍江路口", "南京建國路口", "捷運松江南京站", "南京吉林路口", "南京林森路口", "捷運中山站(志仁高中)", "後車站"]
    let stopTime = ["0","0", "0", "0", "5", "8", "9", "13", "15", "3", "8", "9", "1", "1", "4", "8"]
    // -1:末班駛離(灰) 0: 未發車(灰) 1~2: 進站中(黃) 3~5:時間(淺藍) 5+:時間(藍)
    
    let dirextionList = ["圓環", "南港高工"]
    
    var busName = "棕 9 南京幹線"
    var isUserArrive = false
    var dirStatus = 0
    var addBusBtn = 0
    
    var isFromFav = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = busName
        
        stopsListView.delegate = self
        stopsListView.dataSource = self
        
        
        nowLabel.accessibilityElementsHidden = true
        changeLabel.accessibilityElementsHidden = true
        nowDirectionLabel.accessibilityElementsHidden = true
        changeDirectionLabel.accessibilityElementsHidden = true
        changeDirectionBtn.accessibilityLabel = "現在方向往。" + dirextionList[0] + "。點擊切換往。" + dirextionList[1]
        
        nowDirectionLabel.text = dirextionList[0]
        changeDirectionLabel.text = dirextionList[1]
        changeDirectionBtn.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        
        // add Fav Bus button
        addBusBtn = 0
        let startBtnEmpty = UIBarButtonItem(image: UIImage(named: "searchBus_icon_start_empty"), style: .done, target: self, action:#selector(clickAddBusButton) )
        navigationItem.rightBarButtonItem = startBtnEmpty
        navigationItem.rightBarButtonItem?.accessibilityLabel = "加入常用公車"
        navigationItem.rightBarButtonItem?.accessibilityTraits = UIAccessibilityTraits.none
        
        if isFromFav == 1 {
            navigationItem.rightBarButtonItem = nil
        }
        
        let isUserArriveRef = Database.database().reference().child("isUserArrive")
        
        isUserArriveRef.observe(DataEventType.value, with: { (snapshot) in
            let retrievedDict = snapshot.value as? Bool
            self.isUserArrive = retrievedDict ?? self.isUserArrive
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = UIColor(patternImage: UIImage(named: "searchBus_section_bg")!)
        let label = UILabel()
        label.frame = CGRect.init(x: 40, y: 10, width: 375-80, height: 24)
        label.numberOfLines = 0
        label.textColor = UIColor(rgb: 0xffffff)
        
        label.text = "請選擇搭乘站"
        
        headerView.addSubview(label)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stopsList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchBusStopCellID", for: indexPath) as! SearchBusStopCell
        
        var index = indexPath.row
        
        if dirStatus != 0 {
            index = stopsList.count - index - 1
        }
        
        cell.searchBusStopNameLabel.text = stopsList[index]
        
        cell.searchBusStopBgImg.image = UIImage(named: "searchBus_stop_blue")
        cell.searchBusStopTimeLabel.text = stopTime[index] + " 分鐘進站"
        cell.searchBusStopBookLabel.text = "預約"
        cell.searchBusStopNameLabel.textColor = UIColor(rgb: 0xffffff)
        cell.searchBusStopTimeLabel.textColor = UIColor(rgb: 0xffffff)
        cell.searchBusStopBookLabel.textColor = UIColor(rgb: 0xffffff)
        
        if Int(stopTime[index]) ?? 0 == 0 {
            cell.searchBusStopBgImg.image = UIImage(named: "searchBus_stop_gray")
            cell.searchBusStopTimeLabel.text = "未發車"
            cell.searchBusStopBookLabel.text = ""
        } else if Int(stopTime[index]) ?? 0 == -1 {
            cell.searchBusStopBgImg.image = UIImage(named: "searchBus_stop_gray")
            cell.searchBusStopTimeLabel.text = "末班駛離"
            cell.searchBusStopBookLabel.text = ""
        } else if Int(stopTime[index]) ?? 0 < 3 {
            cell.searchBusStopBgImg.image = UIImage(named: "searchBus_stop_yellow")
            cell.searchBusStopTimeLabel.text = "進站中"
            cell.searchBusStopBookLabel.text = ""
            cell.searchBusStopNameLabel.textColor = UIColor(rgb: 0x000000)
            cell.searchBusStopTimeLabel.textColor = UIColor(rgb: 0x000000)
            cell.searchBusStopBookLabel.textColor = UIColor(rgb: 0x000000)
        } else if Int(stopTime[index]) ?? 0 < 6 {
//            cell.searchBusStopBgImg.image = UIImage(named: "searchBus_stop_lightBlue")
            cell.searchBusStopBgImg.image = UIImage(named: "searchBus_stop_yellow")
            cell.searchBusStopTimeLabel.text = stopTime[index] + " 分鐘進站"
            cell.searchBusStopBookLabel.text = ""
            cell.searchBusStopNameLabel.textColor = UIColor(rgb: 0x000000)
            cell.searchBusStopTimeLabel.textColor = UIColor(rgb: 0x000000)
            cell.searchBusStopBookLabel.textColor = UIColor(rgb: 0x000000)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var index = indexPath.row
        
        if dirStatus != 0 {
            index = stopsList.count - index - 1
        }
        
        // all change to select action at first
        
        let controller = UIAlertController(title: "選擇要進行的動作", message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title:"預約上車", style: .default) { (_) in
                                                
            // ~~~
            
            if self.isUserArrive == false {
                let alertController = UIAlertController(title: "提醒您，到達等候區時才可啟動預約功能", message: nil, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "確認", style: .cancel) { (_) in }
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
            } else if Int(self.stopTime[index]) ?? 0 == 0 {
                let alertController = UIAlertController(title: "尚未發車，請預約其他公車", message: nil, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "確認", style: .cancel) { (_) in }
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
            } else if Int(self.stopTime[index]) ?? 0 == -1 {
                let alertController = UIAlertController(title: "末班駛離，請預約其他公車", message: nil, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "確認", style: .cancel) { (_) in }
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
            } else if Int(self.stopTime[index]) ?? 0 < 3 {
                let alertController = UIAlertController(title: "公車進站中無法預約，是否要預約下一班 " + self.busName + " 還有 8 分鐘進站", message: nil, preferredStyle: .alert)
                let acceptAction = UIAlertAction(title: "是", style: .default) { (_) in
                    let bookedView = self.storyboard?.instantiateViewController(withIdentifier: "bookNoDestinationViewID") as! BookedRouteNoDestinationViewController
                    
                    bookedView.busSection = 0
                    bookedView.busName = self.busName
                    bookedView.busRow = 0
                    bookedView.routeName = "route2"
                    bookedView.startStop = self.stopsList[index]
                    bookedView.nowSectionOfRoute = 0
                    bookedView.sectionCount = 2
                    Database.database().reference().child("isBook").setValue(1)
                    bookedView.modalPresentationStyle = .fullScreen
                    self.present(bookedView, animated: true, completion: nil)
                }
                alertController.addAction(acceptAction)
                
                let cancelAction = UIAlertAction(title: "否", style: .cancel) { (_) in
                }
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
            } else if Int(self.stopTime[index]) ?? 0 < 6 {
                let alertController = UIAlertController(title: "將在5分鐘內進站的公車無法預約，是否要預約下一班 " + self.busName + " 還有 8 分鐘進站", message: nil, preferredStyle: .alert)
                let acceptAction = UIAlertAction(title: "是", style: .default) { (_) in
                let bookedView = self.storyboard?.instantiateViewController(withIdentifier: "bookNoDestinationViewID") as! BookedRouteNoDestinationViewController
                    
                    bookedView.busSection = 0
                    bookedView.busName = self.busName
                    bookedView.busRow = 0
                    bookedView.routeName = "route2"
                    bookedView.startStop = self.stopsList[index]
                    bookedView.nowSectionOfRoute = 0
                    bookedView.sectionCount = 2
                    Database.database().reference().child("isBook").setValue(1)
                    bookedView.modalPresentationStyle = .fullScreen
                    self.present(bookedView, animated: true, completion: nil)
                    
                }
                alertController.addAction(acceptAction)
                
                let cancelAction = UIAlertAction(title: "否", style: .cancel) { (_) in
                }
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
            } else {
                let bookedView = self.storyboard?.instantiateViewController(withIdentifier: "bookNoDestinationViewID") as! BookedRouteNoDestinationViewController
                
                bookedView.busSection = 0
                bookedView.busName = self.busName
                bookedView.busRow = 0
                bookedView.routeName = "route2"
                bookedView.startStop = self.stopsList[index]
                bookedView.nowSectionOfRoute = 0
                bookedView.sectionCount = 2
                Database.database().reference().child("isBook").setValue(1)
                bookedView.modalPresentationStyle = .fullScreen
                self.present(bookedView, animated: true, completion: nil)
            }
            
            // ~~~
            
        }
        controller.addAction(action)
        
        let action2 = UIAlertAction(title:"加入常用站牌", style: .default) { (_) in
            let alertController = UIAlertController(title: "加入常用站牌：\n" + self.stopsList[index], message: nil, preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "確認", style: .default) { (_) in
                
                let alertMessage = UIAlertController(title: "已加入常用站牌", message: nil, preferredStyle: .alert)
                self.present(alertMessage, animated: true)
                // only show n second
                let when = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: when){
                  alertMessage.dismiss(animated: true, completion: nil)
                }
            }
            alertController.addAction(confirmAction)
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
            
            
        }
        controller.addAction(action2)

        let cancelAction = UIAlertAction(title: "取消預約", style: .cancel){ (_) in
        }
        controller.addAction(cancelAction)

        present(controller, animated: true, completion: nil)
        
        // --------
        /*
        if isUserArrive == false {
            let alertController = UIAlertController(title: "提醒您，到達等候區時可啟動預約功能", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "確認", style: .cancel) { (_) in }
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        } else if Int(stopTime[index]) ?? 0 == 0 {
            let alertController = UIAlertController(title: "尚未發車，請預約其他公車", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "確認", style: .cancel) { (_) in }
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        } else if Int(stopTime[index]) ?? 0 == -1 {
            let alertController = UIAlertController(title: "末班駛離，請預約其他公車", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "確認", style: .cancel) { (_) in }
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        } else if Int(stopTime[index]) ?? 0 < 3 {
            let alertController = UIAlertController(title: "公車進站中無法預約，是否要預約下一班 " + self.busName + " 還有 8 分鐘進站", message: nil, preferredStyle: .alert)
            let acceptAction = UIAlertAction(title: "是", style: .default) { (_) in
                let bookedView = self.storyboard?.instantiateViewController(withIdentifier: "bookNoDestinationViewID") as! BookedRouteNoDestinationViewController
                
                bookedView.busSection = 0
                bookedView.busName = self.busName
                bookedView.busRow = 0
                bookedView.routeName = "route2"
                bookedView.startStop = self.stopsList[index]
                bookedView.nowSectionOfRoute = 0
                bookedView.sectionCount = 2
                Database.database().reference().child("isBook").setValue(1)
                bookedView.modalPresentationStyle = .fullScreen
                self.present(bookedView, animated: true, completion: nil)
            }
            alertController.addAction(acceptAction)
            
            let cancelAction = UIAlertAction(title: "否", style: .cancel) { (_) in
            }
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        } else if Int(stopTime[index]) ?? 0 < 6 {
            let alertController = UIAlertController(title: "將在5分鐘內進站的公車無法預約，是否要預約下一班 " + self.busName + " 還有 8 分鐘進站", message: nil, preferredStyle: .alert)
            let acceptAction = UIAlertAction(title: "是", style: .default) { (_) in
            let bookedView = self.storyboard?.instantiateViewController(withIdentifier: "bookNoDestinationViewID") as! BookedRouteNoDestinationViewController
                
                bookedView.busSection = 0
                bookedView.busName = self.busName
                bookedView.busRow = 0
                bookedView.routeName = "route2"
                bookedView.startStop = self.stopsList[index]
                bookedView.nowSectionOfRoute = 0
                bookedView.sectionCount = 2
                Database.database().reference().child("isBook").setValue(1)
                bookedView.modalPresentationStyle = .fullScreen
                self.present(bookedView, animated: true, completion: nil)
                
            }
            alertController.addAction(acceptAction)
            
            let cancelAction = UIAlertAction(title: "否", style: .cancel) { (_) in
            }
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        } else {
            let controller = UIAlertController(title: "選擇要進行的動作" + self.busName, message: nil, preferredStyle: .actionSheet)
            let action = UIAlertAction(title:"預約上車", style: .default) { (_) in
                                                    
                let bookedView = self.storyboard?.instantiateViewController(withIdentifier: "bookNoDestinationViewID") as! BookedRouteNoDestinationViewController
                
                bookedView.busSection = 0
                bookedView.busName = self.busName
                bookedView.busRow = 0
                bookedView.routeName = "route2"
                bookedView.startStop = self.stopsList[index]
                bookedView.nowSectionOfRoute = 0
                bookedView.sectionCount = 2
                Database.database().reference().child("isBook").setValue(1)
                bookedView.modalPresentationStyle = .fullScreen
                self.present(bookedView, animated: true, completion: nil)
                
            }
            controller.addAction(action)
            
            let action2 = UIAlertAction(title:"加入常用站牌", style: .default) { (_) in
                
            }
            controller.addAction(action2)

            let cancelAction = UIAlertAction(title: "取消預約", style: .cancel){ (_) in
            }
            controller.addAction(cancelAction)

            present(controller, animated: true, completion: nil)
        }
        
        */
        
    }
    
    @objc func clickButton() {
        dirStatus = (dirStatus + 1 ) % 2
        stopsListView.reloadData()
        nowDirectionLabel.text =  dirextionList[dirStatus]
        changeDirectionLabel.text = dirextionList[ (dirStatus + 1 ) % 2]
//        changeDirectionLabel.accessibilityLabel = "點擊切換往。" + (dirextionList[ (dirStatus + 1 ) % 2])
        changeDirectionBtn.accessibilityLabel = "現在方向往。" + dirextionList[dirStatus] + "。點擊切換往。" + dirextionList[ (dirStatus + 1 ) % 2]
    }

    @objc func clickAddBusButton() {
        addBusBtn = (addBusBtn + 1 ) % 2
        if addBusBtn == 0 {
            let startBtnEmpty = UIBarButtonItem(image: UIImage(named: "searchBus_icon_start_empty"), style: .done, target: self, action:nil )
            navigationItem.rightBarButtonItem = startBtnEmpty
            navigationItem.rightBarButtonItem?.accessibilityLabel = "加入常用公車"
            
        } else {
            let startBtnFull = UIBarButtonItem(image: UIImage(named: "searchBus_icon_start_full"), style: .done, target: self, action:nil)
            navigationItem.rightBarButtonItem = startBtnFull
            navigationItem.rightBarButtonItem?.accessibilityLabel = "已加入常用公車"
            
        }
//        navigationItem.rightBarButtonItem?.accessibilityTraits = UIAccessibilityTraits.none
        
        let alertController = UIAlertController(title: "已加入常用公車", message: nil, preferredStyle: .alert)
        present(alertController, animated: true)
        
        // only show n second
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
          alertController.dismiss(animated: true, completion: nil)
        }
    }
}
