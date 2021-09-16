//
//  ViewController.swift
//  Medly
//
//  Created by Aaron London on 9/15/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var countries = [Country]()
    
    let identifier = "countryCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(CountryCell.self, forCellReuseIdentifier: identifier)

        let task = URLSession.shared.dataTask(with: URLRequest(url: URL(string: "https://restcountries.eu/rest/v2/all")!)) { data, response, error in
            guard let data = data else { return }
            self.countries = try! JSONDecoder().decode([Country].self, from: data)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

        task.resume()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? CountryCell else {
            return UITableViewCell()
        }
        let model: Country = countries[indexPath.row]
        cell.setUp(with: model)
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
}

protocol AutoConfiguringCell {
    associatedtype Model
    func setUp(with model: Model)
}

class CountryCell: UITableViewCell, AutoConfiguringCell {
    typealias Model = Country

    func setUp(with model: Country) {
        self.textLabel?.text = "\(model.name) - \(model.capital)"
    }
}
