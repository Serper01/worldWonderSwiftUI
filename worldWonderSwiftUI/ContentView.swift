//
//  ContentView.swift
//  worldWonderSwiftUI
//
//  Created by Serper Kurmanbek on 20.01.2024.
//

import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI

struct CarBrands: Identifiable{
    var id = UUID()
    var name = ""
    var region = ""
    var location = ""
    var flag = ""
    var picture = ""
    
    init(json: JSON) {
        if let item = json["name"].string{
            name = item
        }
        if let item = json["region"].string{
            region = item
        }
        if let item = json["location"].string{
            location = item
        }
        if let item = json["flag"].string{
            flag = item
        }
        if let item = json["picture"].string{
            picture = item
        }
        
    }
}
    
    struct BrandsRow: View {
        
        var carsItem: CarBrands
        
        var body: some View {
            HStack{
                WebImage(url: URL(string: carsItem.picture))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100,height: 100)
                    .clipped()
                    .cornerRadius(6)
                VStack(alignment: .leading, spacing: 4) {
                    Text(carsItem.name)
                    Text(carsItem.region)
                    HStack{
                        WebImage(url: URL(string: carsItem.flag))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30,height: 20)
                        
                        Text (carsItem.location)
                    }
                }
            }
        }
        
        
    }
    
    struct ContentView: View {
        @ObservedObject var carsList = GetBrands()
        var body: some View {
            NavigationView{
                List(carsList.carsArray) { carsItem in
                BrandsRow(carsItem: carsItem)
                }
                .refreshable {
                    self.carsList.updateData()
                }
                .navigationTitle("Car Brands")
            }
        }
    }
    
    #Preview {
        ContentView()
    }
class GetBrands: ObservableObject {
  @Published  var carsArray = [CarBrands]()
    
    init(){
        updateData()
    }
    
    func updateData() {
        let urlString = "https://demo7478991.mockable.io/CarBrands"
        let url = URL(string: urlString)
        let session = URLSession(configuration: .default)
        session.dataTask(with: url!) { (data, _, error) in
            if error != nil {
                print (error?.localizedDescription)
                return
            }
            let json = try! JSON(data:data!)
            if let resultArray = json.array{
                self.carsArray.removeAll()
                for item in resultArray{
                    let carsItem = CarBrands(json: item)
                        DispatchQueue.main.async{
                        self.carsArray.append(carsItem)
                    }
                   
                }
            }
        } .resume()
    }
}
