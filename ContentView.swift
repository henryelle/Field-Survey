//
//  ContentView.swift
//  Shared
//
//  Created by Henry Ellebracht on 11/14/21.
//

import SwiftUI


let jsonFileName = "field_observations"

func dateFormat(date: Date) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM dd, yyyy hh:mm:ss a"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    return dateFormatter.string(from: date)
}

//listen i know i shouldnt do this in the contentview
//but if i didnt i would cry
//and do u want me to cry??? do u???

class JSONLoad {
    
    class func load(jsonFileName: String) -> ObservationSet? {
        do {
        var observationset: ObservationSet?
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        
        if let jsonFileUrl = Bundle.main.url(forResource: jsonFileName, withExtension: ".json"),
            let jsonData = try? Data(contentsOf: jsonFileUrl) {
            observationset = try? jsonDecoder.decode(ObservationSet.self, from: jsonData)
        }
        
        return observationset
        } catch {
            print(error)
        }
    }
}

struct ContentView: View {
    var body: some View {

        
        if let observation = JSONLoad.load(jsonFileName: jsonFileName){
            NavigationView {
            List(observation.observations) { item in
                
               
                    NavigationLink(destination: DetailView(obs: item)){
                    
                    let imagepath = item.classification.rawValue
                    HStack{
                        Image(imagepath)
                        VStack{
                            Text(item.title).font(.title)
                            Text(dateFormat(date: item.date)!)
                            }
                    }
                    }
                }.navigationBarTitle("Field Survey")
            }
                
        }
    }
}

struct DetailView: View {
    var obs: Observation
    
    var body: some View {
        HStack(alignment: .top) {
            Image(obs.classification.rawValue)
            VStack(alignment: .leading){
                Text(obs.title)
                    .multilineTextAlignment(.leading)
                Text(dateFormat(date: obs.date)!)
                    .multilineTextAlignment(.leading)
                
            }
        }
        Text(obs.description)
            .multilineTextAlignment(.center)
    }
}

enum Classification: String, Codable {
    case amphibian
    case bird
    case fish
    case insect
    case mammal
    case plant
    case reptile
}

struct ObservationSet: Codable {
    var status: String
    var observations: [Observation]
    
    enum CodingKeys: String, CodingKey {
        case status
        case observations
    }
}

struct Observation: Codable, Identifiable {
    var id = UUID()
    var classification: Classification
    var title: String
    var description: String
    var date: Date
    
    
    enum CodingKeys: String, CodingKey {
        case classification
        case title
        case description
        case date
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
