//
//  AlertsViewController.swift
//  Weather
//
//  Created by Pavol Adamík on 01/05/2022.
//

import UIKit

class AlertsViewController: UIViewController {
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var alertDesctiptionLabel: UILabel!
    
    // MARK: - Static
    
    private var alert = AlertsOfWeather()// = AlertsOfWeather()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //skuska()
        // if alert != nil {
        //     setupView(with: alert)
        // }
        
        alert.title = WeatherDetailViewController.wd?.alert[0].title ?? "Alerts"
        alert.description = WeatherDetailViewController.wd?.alert[0].description ?? "No alerts for this city"
        setupView(with: alert)

    }

}

extension AlertsViewController {
    func setupView(with alert: AlertsOfWeather) {
        eventNameLabel.text = alert.title
        alertDesctiptionLabel.text = alert.description
    }
}


extension AlertsViewController {
    func skuska() {
        eventNameLabel.text = "Nizke teploty päť stupňov Celzia. Slovenský hydrometeorologický ústav (SHMÚ) preto vydal výstrahu 1. stupňa.V časti Bratislavského, Trnavského, Nitrianskeho a Banskobystrického kraja sa očakáva aj prízemný mráz. Vo výške päť centimetrov na XX"
        alertDesctiptionLabel.text = "BRATISLAVA - Meteorológovia varujú pred mrazom, ktorý sa môže v noci na nedeľu (10. 4.) vyskytnúť vo všetkých krajoch na Slovensku. Teplota miestami klesne na mínus jeden až mínus štyri, na severe až na mínus päť stupňov Celzia. Slovenský hydrometeorologický ústav (SHMÚ) preto vydal výstrahu 1. stupňa.V časti Bratislavského, Trnavského, Nitrianskeho a Banskobystrického kraja sa očakáva aj prízemný mráz. Vo výške päť centimetrov nad povrchom sa očakáva dosiahnutie minimálnej teploty vzduchu mínus jeden až mínus dva stupne Celzia.BANSKÁ BYSTRICA - Slovenský hydrometeorologický ústav (SHMÚ) upozorňuje na hmlu. Vydal výstrahy prvého stupňa pre okresy Banskobystrického, Trenčianskeho, Košického, Prešovského a Žilinského kraja. Informuje o tom na svojom webe.V týchto oblastiach sa očakáva výskyt hmiel s dohľadnosťou 50 až 200 metrov. Znížená dohľadnosť predstavuje potenciálne nebezpečenstvo pre dopravné aktivity. Výskyt hmiel s uvedenou dohľadnosťou je v danej ročnej dobe a oblasti bežný, ale môže spôsobiť škody menšieho rozsahu, upozorňuje SHMÚ.BRATISLAVA - Meteorológovia varujú pred mrazom, ktorý sa môže v noci na nedeľu (10. 4.) vyskytnúť vo všetkých krajoch na Slovensku. Teplota miestami klesne na mínus jeden až mínus štyri, na severe až na mínus päť stupňov Celzia. Slovenský hydrometeorologický ústav (SHMÚ) preto vydal výstrahu 1. stupňa.V časti Bratislavského, Trnavského, Nitrianskeho a Banskobystrického kraja sa očakáva aj prízemný mráz. Vo výške päť centimetrov nad povrchom sa očakáva dosiahnutie minimálnej teploty vzduchu mínus jeden až mínus dva stupne Celzia."
    }
}
