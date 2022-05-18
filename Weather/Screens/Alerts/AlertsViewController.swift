//
//  AlertsViewController.swift
//  Weather
//
//  Created by Pavol Adamík on 01/05/2022.
//

import UIKit

class AlertsViewController: UIViewController { // budu samozrejme len v anglictine.. ked su alerty tak to zobrazi ale ked to neposkytuje alerty tak to jebne
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var alertDesctiptionLabel: UILabel!
    @IBOutlet weak var senderNameLabel: UILabel!

    
    // MARK: - Staticfrom
    
    private var alert = AlertsOfWeather()// = AlertsOfWeather()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //skuska()
        // if alert != nil {
        //     setupView(with: alert)
        // }
        
       // if alert == 0 {
            
       // }
        if alert.description == "" {
            print("alert je ' ") //takze to je "
        }
        
        if alert != nil {
            print("alert nie je nil")
        }
                                
       // if (WeatherDetailViewController.wd?.alert[0].title == "") {
//        if alert.description == "" {
//            alert.title = "Alerts"
//            alert.description = "No alerts for this city at this time!"
//            alert.sender_name = "Nobody"
//        } else {
        
        alert.title = WeatherDetailViewController.wd?.alert?[0].title ?? "Alerts"
        alert.description = WeatherDetailViewController.wd?.alert?[0].description ?? "No alerts for this city"
        alert.sender_name = WeatherDetailViewController.wd?.alert?[0].sender_name ?? "If there is no article, there is no author"
        setupView(with: alert)
//        }

    }

}

extension AlertsViewController {
    func setupView(with alert: AlertsOfWeather) {
        eventNameLabel.text = alert.title
        alertDesctiptionLabel.text = alert.description
        senderNameLabel.text = alert.sender_name
    }
}


extension AlertsViewController {
    func skuska() {
        eventNameLabel.text = "Nizke teploty päť stupňov Celzia. Slovenský hydrometeorologický ústav (SHMÚ) preto vydal výstrahu 1. stupňa.V časti Bratislavského, Trnavského, Nitrianskeho a Banskobystrického kraja sa očakáva aj prízemný mráz. Vo výške päť centimetrov na XX"
        alertDesctiptionLabel.text = "BRATISLAVA - Meteorológovia varujú pred mrazom, ktorý sa môže v noci na nedeľu (10. 4.) vyskytnúť vo všetkých krajoch na Slovensku. Teplota miestami klesne na mínus jeden až mínus štyri, na severe až na mínus päť stupňov Celzia. Slovenský hydrometeorologický ústav (SHMÚ) preto vydal výstrahu 1. stupňa.V časti Bratislavského, Trnavského, Nitrianskeho a Banskobystrického kraja sa očakáva aj prízemný mráz. Vo výške päť centimetrov nad povrchom sa očakáva dosiahnutie minimálnej teploty vzduchu mínus jeden až mínus dva stupne Celzia.BANSKÁ BYSTRICA - Slovenský hydrometeorologický ústav (SHMÚ) upozorňuje na hmlu. Vydal výstrahy prvého stupňa pre okresy Banskobystrického, Trenčianskeho, Košického, Prešovského a Žilinského kraja. Informuje o tom na svojom webe.V týchto oblastiach sa očakáva výskyt hmiel s dohľadnosťou 50 až 200 metrov. Znížená dohľadnosť predstavuje potenciálne nebezpečenstvo pre dopravné aktivity. Výskyt hmiel s uvedenou dohľadnosťou je v danej ročnej dobe a oblasti bežný, ale môže spôsobiť škody menšieho rozsahu, upozorňuje SHMÚ.BRATISLAVA - Meteorológovia varujú pred mrazom, ktorý sa môže v noci na nedeľu (10. 4.) vyskytnúť vo všetkých krajoch na Slovensku. Teplota miestami klesne na mínus jeden až mínus štyri, na severe až na mínus päť stupňov Celzia. Slovenský hydrometeorologický ústav (SHMÚ) preto vydal výstrahu 1. stupňa.V časti Bratislavského, Trnavského, Nitrianskeho a Banskobystrického kraja sa očakáva aj prízemný mráz. Vo výške päť centimetrov nad povrchom sa očakáva dosiahnutie minimálnej teploty vzduchu mínus jeden až mínus dva stupne Celzia."
    }
}
