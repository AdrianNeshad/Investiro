//
//  FeedViewModel.swift
//  Investiro
//
//  Created by Adrian Neshad on 2025-11-08.
//

import Foundation
import Combine
import SwiftUI
 
 class FeedViewModel: ObservableObject {
     @Published var isLoading: Bool = false
     @Published var newsItems: [NewsItem] = []
     @Published var partialItems: [NewsItem] = []
     @Published var currentCategory: Category = .noje
     @Published var currentCustomCategory: CustomCategory? = nil
 
     @Published var activeSources: Set<String> = [] {
         didSet { saveActiveSources() }
     }
 
     @Published var customSources: [Category: [NewsSource]] = [:] {
         didSet { saveCustomSources() }
     }
 
     @Published var customCategorySources: [UUID: [NewsSource]] = [:] {
         didSet { saveCustomCategorySources() }
     }
 
     @Published var customCategories: [CustomCategory] = [] {
         didSet { saveCustomCategories() }
     }
 
     private var categoryKey: String {
         if let custom = currentCustomCategory {
             return "activeSources_custom_\(custom.id.uuidString)"
         } else {
             return "activeSources_\(currentCategory.rawValue)"
         }
     }
 
     var filteredSources: [NewsSource] {
         if let custom = currentCustomCategory {
             let customList = customCategorySources[custom.id] ?? []
             return customList.filter { activeSources.isEmpty || activeSources.contains($0.name) }
         } else {
             let standard = currentCategory.sources
             let custom = customSources[currentCategory] ?? []
             let all = standard + custom
           return all.filter { activeSources.isEmpty || activeSources.contains($0.name) }
       }
   }

   init() {
       loadCustomSources()
       loadCustomCategories()
       loadCustomCategorySources()
       loadActiveSources()
       loadNews()
   }

   func setCategory(_ category: Category) {
       currentCategory = category
       currentCustomCategory = nil
       loadActiveSources()
       loadNews()
   }

   func setCustomCategory(_ category: CustomCategory) {
       currentCustomCategory = category
       currentCategory = .noje
       loadActiveSources()
       loadNews()
   }

   func addCustomCategory(name: String, icon: String) {
       let new = CustomCategory(name: name, icon: icon)
       customCategories.append(new)
       customCategorySources[new.id] = []
       activeSources = []
       setCustomCategory(new)
   }

   func removeCustomCategory(_ category: CustomCategory) {
       customCategories.removeAll { $0.id == category.id }
       customCategorySources[category.id] = nil
       UserDefaults.standard.removeObject(forKey: "activeSources_custom_\(category.id.uuidString)")
       if currentCustomCategory?.id == category.id {
           currentCustomCategory = nil
       }
       loadNews()
   }

   func saveCustomSources() {
       let encoder = JSONEncoder()
       if let data = try? encoder.encode(customSources) {
           UserDefaults.standard.set(data, forKey: "customSources")
       }
   }

   func loadCustomSources() {
       if let data = UserDefaults.standard.data(forKey: "customSources") {
           let decoder = JSONDecoder()
           if let decoded = try? decoder.decode([Category: [NewsSource]].self, from: data) {
               customSources = decoded
           }
       }
   }

   func saveCustomCategories() {
       if let data = try? JSONEncoder().encode(customCategories) {
           UserDefaults.standard.set(data, forKey: "customCategories")
       }
   }

   func loadCustomCategories() {
       if let data = UserDefaults.standard.data(forKey: "customCategories"),
          let decoded = try? JSONDecoder().decode([CustomCategory].self, from: data) {
           customCategories = decoded
       }
   }

   func saveCustomCategorySources() {
       if let data = try? JSONEncoder().encode(customCategorySources) {
           UserDefaults.standard.set(data, forKey: "customCategorySources")
       }
   }

   func loadCustomCategorySources() {
       if let data = UserDefaults.standard.data(forKey: "customCategorySources"),
          let decoded = try? JSONDecoder().decode([UUID: [NewsSource]].self, from: data) {
           customCategorySources = decoded
       }
   }

   func saveActiveSources() {
       let joined = activeSources.joined(separator: "|")
       UserDefaults.standard.setValue(joined, forKey: categoryKey)
   }

   func loadActiveSources() {
       let saved = UserDefaults.standard.string(forKey: categoryKey)?.split(separator: "|").map(String.init) ?? []

       let allNames: [String] = {
           if let custom = currentCustomCategory {
               return (customCategorySources[custom.id] ?? []).map { $0.name }
           } else {
               return (currentCategory.sources + (customSources[currentCategory] ?? [])).map { $0.name }
           }
       }()

       guard !allNames.isEmpty else {
           activeSources = []
           return
       }

       let validSaved = saved.filter { allNames.contains($0) }
       if !validSaved.isEmpty {
           activeSources = Set(validSaved)
       } else {
           if currentCategory == .polisen {
               let defaultPolice = ["Pressmeddelanden", "Nyheter"]
               activeSources = Set(allNames.filter { defaultPolice.contains($0) })
           } else {
               activeSources = Set(allNames)
           }
       }
   }

     func loadNews() {
         print("🔄 Laddar nyheter för kategori: \(currentCategory.rawValue)")
        print("📡 Aktiva källor: \(filteredSources.map { $0.name })")
         
         isLoading = true
         newsItems = []
         partialItems = []

         if filteredSources.isEmpty {
             print("⚠️ Inga aktiva källor – laddar inget")
             isLoading = false
             return
         }

         var seen = Set<String>()

         for source in filteredSources {
             let url = source.url ?? feedURL(for: source.name)
             guard let feedURL = url else { continue }

             let rssFetcher = RSSFetcher()
             rssFetcher.fetchFeed(from: feedURL, source: source) { result in
                 DispatchQueue.main.async {
                     switch result {
                     case .success(let items):
                         let newItems = items.filter { item in
                             let key = "\(item.title)-\(item.pubDate?.timeIntervalSince1970 ?? 0)"
                             if seen.contains(key) {
                                 return false
                             } else {
                                 seen.insert(key)
                                 return true
                             }
                         }
                         self.partialItems.append(contentsOf: newItems)
                         self.partialItems.sort(by: { ($0.pubDate ?? Date.distantPast) > ($1.pubDate ?? Date.distantPast) })

                     case .failure(let error):
                         print("RSS-fel för källa \(source.name): \(error.localizedDescription)")
                     }

                     // Om alla är färdiga – kolla om det är sista
                     if self.partialItems.count >= self.newsItems.count {
                         self.isLoading = false
                     }
                 }
             }
         }
     }

    
    func feedURL(for sourceName: String) -> URL? {
        switch sourceName {
            //USA
            //Nyheter
        case "NBC News":
            return URL(string: "https://feeds.nbcnews.com/nbcnews/public/news")
        case "ABC News":
            return URL(string: "https://abcnews.go.com/abcnews/topstories")
        case "CBS News":
            return URL(string: "https://www.cbsnews.com/latest/rss/main")
        case "The New York Times":
            return URL(string: "https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml")
        case "Fox News":
            return URL(string: "https://moxie.foxnews.com/google-publisher/latest.xml")
        case "Wall Street Journal":
            return URL(string: "https://feeds.content.dowjones.io/public/rss/RSSUSnews")
            //Myndigheter
        case "U.S. Department of Defense":
            return URL(string: "https://www.defense.gov/DesktopModules/ArticleCS/RSS.ashx?max=10&ContentType=1&Site=945")
        case "U.S. Courts":
            return URL(string: "https://www.uscourts.gov/news/rss")
        case "Federal Reserve":
            return URL(string: "https://www.federalreserve.gov/feeds/press_all.xml")
        case "FBI National Press Releases":
            return URL(string: "https://www.fbi.gov/feeds/national-press-releases/rss.xml")
        case "U.S. Department of State":
            return URL(string: "https://www.state.gov/rss-feed/press-releases/feed/")
            //Finans
        case "Financial Times":
            return URL(string: "https://www.ft.com/rss/home")
        case "CBS Moneywatch":
            return URL(string: "https://www.cbsnews.com/latest/rss/moneywatch")
        case "ABC Business":
            return URL(string: "https://abcnews.go.com/abcnews/moneyheadlines")
        case "Bloomberg":
            return URL(string: "https://feeds.bloomberg.com/economics/news.rss")
            //Sport
        case "Sky Sports":
            return URL(string: "https://www.skysports.com/rss/12040")
        case "Fox Sports":
            return URL(string: "https://api.foxsports.com/v2/content/optimized-rss?partnerKey=MB0Wehpmuj2lUhuRhQaafhBjAJqaPU244mlTDK1i&size=30")
        case "CBS Sports":
            return URL(string: "https://www.cbssports.com/rss/headlines/")
        case "ESPN":
            return URL(string: "https://www.espn.com/espn/rss/news")
            //Fotboll
        case "ESPN Soccer":
            return URL(string: "https://www.espn.com/espn/rss/soccer/news")
        case "Fox Sports Soccer":
            return URL(string: "https://api.foxsports.com/v2/content/optimized-rss?partnerKey=MB0Wehpmuj2lUhuRhQaafhBjAJqaPU244mlTDK1i&size=30&tags=fs/soccer,soccer/epl/league/1,soccer/mls/league/5,soccer/ucl/league/7,soccer/europa/league/8,soccer/wc/league/12,soccer/euro/league/13,soccer/wwc/league/14,soccer/nwsl/league/20,soccer/cwc/league/26,soccer/gold_cup/league/32,soccer/unl/league/67")
            
            //Finland
            //Nyheter
        case "Helsingin Sanomat":
            return URL(string: "https://www.hs.fi/rss/teasers/etusivu.xml")
        case "Yle":
            return URL(string: "https://yle.fi/rss/uutiset/paauutiset")
        case "Iltalehti":
            return URL(string: "https://www.iltalehti.fi/rss/uutiset.xml")
        case "Ilta-Sanomat":
            return URL(string: "https://www.is.fi/rss/tuoreimmat.xml")
            //Myndigheter
        case "Eduskunta":
            return URL(string: "https://www.eduskunta.fi/_layouts/15/feed.aspx?xsl=1&web=%2FFI%2Frss%2Dfeeds&page=a4011b50-8132-4c08-906f-ad8089958fd5&wp=9971a60e-1c4e-4269-9c21-2ab800e34953&pageurl=%2FFI%2Frss%2Dfeeds%2FSivut%2Fkirjalliset%2Dkysymykset%2Easpx")
            //finans
        case "HS - Talous":
            return URL(string: "https://www.hs.fi/rss/talous.xml")
        case "Yle - Talous":
            return URL(string: "https://yle.fi/rss/t/18-204933/fi")
        case "IS - Taloussanomat":
            return URL(string: "https://www.is.fi/rss/taloussanomat.xml")
            //Sport
        case "Yle - Urheilu":
            return URL(string: "https://yle.fi/rss/urheilu")
        case "HS - Urheilu":
            return URL(string: "https://www.hs.fi/rss/urheilu.xml")
        case "IS - Urheilu":
            return URL(string: "https://www.is.fi/rss/urheilu.xml")
            //Fotboll
        case "IS - Jalkapallo":
            return URL(string: "https://www.is.fi/rss/jalkapallo.xml")
            
            
            //Norska
            //nyheter
        case "Aftenposten":
            return URL(string: "https://aftenposten.no/rss")
        case "Verdens Gang":
            return URL(string: "https://vg.no/rss/feed/?format=rss")
        case "NRK":
            return URL(string: "https://www.nrk.no/nyheter/siste.rss")
        case "Dagbladet":
            return URL(string: "https://www.dagbladet.no/?lab_viewport=rss")
        case "Nettavisen":
            return URL(string: "https://www.nettavisen.no/service/rich-rss?tag=nyheter")
        case "TV2":
            return URL(string: "https://www.tv2.no/rss/nyheter")
        case "E24":
            return URL(string: "https://e24.no/rss2/")
            //myndigheter
        case "Norges Bank":
            return URL(string: "https://www.norges-bank.no/RSS/Artikler-og-kronikker-fra-Norges-Bank/")
        case "Regjeringen":
            return URL(string: "https://www.regjeringen.no/en/rss/Rss/2581966/")
        case "Forskningsrådet":
            return URL(string: "https://www.forskningsradet.no/en/call-for-proposals/rss-feed-utlysninger/")
        case "Skatteetaten":
            return URL(string: "https://www.skatteetaten.no/en/rss/presse/pressemeldinger/")
            //finans
        case "Finansavisen":
            return URL(string: "https://ws.finansavisen.no/api/articles.rss")
        case "E24 Børs og finans":
            return URL(string: "https://e24.no/rss2/?seksjon=boers-og-finans")
            //Sport
        case "NRK Sport":
            return URL(string: "https://www.nrk.no/sport/toppsaker.rss")
        case "TV2 Sport":
            return URL(string: "https://www.tv2.no/rss/sport")
            //Fotboll
        case "":
            return URL(string: "")
            
            
            //Svenska
        case "Folkhälsomyndigheten":
            return URL(string: "https://www.folkhalsomyndigheten.se/nyheter-och-press/nyhetsarkiv/?syndication=rss")
        case "Aftonbladet":
            return URL(string: "https://rss.aftonbladet.se/rss2/small/pages/sections/senastenytt/")
        case "Dagens Industri":
            return URL(string: "https://www.di.se/digital/rss")
        case "Fotbollskanalen":
            return URL(string: "https://www.fotbollskanalen.se/rss/")
        case "FotbollsExpressen":
            return URL(string: "https://feeds.expressen.se/fotboll/")
        case "Expressen":
            return URL(string: "https://feeds.expressen.se/nyheter/")
        case "SportExpressen":
            return URL(string: "https://feeds.expressen.se/sport/")
        case "Expressen Ekonomi":
            return URL(string: "https://feeds.expressen.se/ekonomi/")
        case "Svenska Dagbladet":
            return URL(string: "https://www.svd.se/feed/articles.rss")
        case "SVT":
            return URL(string: "https://www.svt.se/nyheter/rss.xml")
        case "TV4":
            return URL(string: "https://www.tv4.se/rss")
        case "Krisinformation":
            return URL(string: "https://www.krisinformation.se/nyheter?rss=true")
        case "MSB":
            return URL(string: "https://www.msb.se/sv/rss-floden/rss-alla-nyheter-fran-msb/")
        case "Regeringen":
            return URL(string: "https://www.regeringen.se/Filter/RssFeed?filterType=Taxonomy&filterByType=FilterablePageBase&preFilteredCategories=1284%2C1285%2C1286%2C1287%2C1288%2C1290%2C1291%2C1292%2C1293%2C1294%2C1295%2C1296%2C1297%2C2425&rootPageReference=0&filteredContentCategories=1334&filteredPoliticalLevelCategories=&filteredPoliticalAreaCategories=&filteredPublisherCategories=1296")
        case "Skatteverket":
            return URL(string: "https://skatteverket.se/4.dfe345a107ebcc9baf800017652/12.dfe345a107ebcc9baf800017658.portlet?state=rss&sv.contenttype=text/xml;charset=UTF-8")
        case "Livsmedelsverket":
            return URL(string: "https://www.livsmedelsverket.se/rss/rss-pressmeddelanden")
        case "Läkemedelsverket":
            return URL(string: "https://www.lakemedelsverket.se/api/newslist/newsrss?query=&pageTypeId=1&from=&to=")
        case "Riksbanken":
            return URL(string: "https://www.riksbank.se/sv/rss/nyheter/")
        case "Dagens Nyheter":
            return URL(string: "https://www.dn.se/rss/")
        case "Fotbolltransfers":
            return URL(string: "https://fotbolltransfers.com/rss/nyheter/alla")
        case "SVT Sport":
            return URL(string: "https://www.svt.se/sport/rss.xml")
        case "Placera":
            return URL(string: "https://www.placera.se/artiklar/rss.xml")
        case "Nasdaq":
            return URL(string: "https://www.nasdaq.com/feed/rssoutbound?category=Stocks")
        default:
            return nil
        }
    }
}
