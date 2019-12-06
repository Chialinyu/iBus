//
//  AboutViewController.swift
//  BusPlusA
//
//  Created by iui on 2019/12/6.
//  Copyright © 2019 Carolyn Yu. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    @IBOutlet weak var contextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "關於此 App"
        
        // Do any additional setup after loading the view.
        contextView.text = "\t此 App 是由科技部計畫所支持的無障礙預約公車系統的 App 客戶端，我們在公車亭裡規劃了一區專門給視障者等車的候車區。使用者在到達公車亭時可以操作此APP預約所要搭乘的公車，並利用語音提醒公車即將進站，請記得到候車區等候上車。在乘車途中也可以即時得知即將到達的站名以及距離目的地還有多少站的語音提示。 \n\t此APP有四種方式可以進行預約公車，分別為 「常用路線」、「規劃路線」、「附近站牌」以及「搜尋公車」。 \n\n 1. 常用路線： \n\t使用者可以根據自己乘車的習慣，儲存常搭乘的公車路線，一旦將搜尋結果從「規劃路線」加入常用路線後，即可直接從「常用路線」裡點擊要搭乘的路線進入預約公車頁面，查看該路線所有公車的等候時間。舉例來說，從 A 站到 B 站，有 1 0 1、2 0 2、3 0 3 三班公車都可抵達，那我們在該路線裡面會把這三班公車都列出來讓你選擇你所想搭乘的公車。 \n\n 2. 規劃路線： \n\t使用者可以輸入起始的公車站名以及欲到達的公車站名進行路線搜尋，按下搜尋按鈕後，搜尋結果會分成「需轉乘路線」以及「直達路線」兩種類型，其中「需轉乘路線」含有一次原地轉乘過程，而「直達路線」提供路線中所有可以搭乘的公車號碼。點擊任一路線皆可進入預約公車頁面，查看該路線所有公車的等候時間。 \n\n 3. 附近站牌： \n\t此功能將列出距離您所在位置五百公尺以內的所有公車站牌，使用者可以點選欲上車的公車站牌，查看經過此公車站牌的所有公車號碼以及需等候時間。點擊任一公車號碼就可選擇是否對該班公車進行預約。 \n\n 4. 搜尋公車： \n\t使用者可以利用公車號碼鍵盤輸入欲搭乘的公車，按下搜尋按鈕後，將會列出符合該條件的所有公車，點擊後可以查看該公車行經的所有公車站牌以及於各站的等候時間，系統將會根據您所在的位置自動移動到離你最近的公車站牌欄位。滑動前後站若發現此方向不是欲搭乘的方向，即可點選畫面上方的切換方向按鈕來進行變更。點選您欲上車的公車站牌即可選擇是否對該班公車進行預約。 \n\n*注意：提醒您不管用以上何種方式來選擇欲搭乘公車，使用者都需要到達該公車站牌才可進行預約公車。 \n\n其他功能定義\n\n1. 預約公車： \n\t此功能可以透過「常用路線」、「規劃路線」、「附近站牌」以及「搜尋公車」來啟動。對欲搭乘的公車進行預約後，使用者可以透過此APP即時之後該班公車還有多久會進站，一旦小於三分鐘，即會顯示即將進站，這時請麻煩前往候車區進行上車準備。 \n\n*注意：提醒您當欲搭乘公車等候時間為五分鐘以內，則無法進行預約公車，系統將詢問是否自動幫你預約同號碼的下一班公車。 \n\n2. 下車提醒： \n\t此功能只能透過「常用路線」以及「規劃路線」啟動。當使用者成功搭上公車時，系統將詢問是否要開啟下車提醒功能，若開啟此功能後，隨時可以透過此APP查看距離目的地還有多少站數以及下一站的站名。而在到達目的地的前三站，開始會主動透過語音的方式推播提醒。 \n\n3. 需轉乘路線： \n\t若從「常用路線」以及「規劃路線」裡選擇需轉乘路線，我們會把路線分成兩段路線，第一段為起點站到轉乘站，第二段為轉乘站到終點站。當抵達轉乘站時，可再透過此APP於轉乘站預約下一段公車。"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
