//
//  Category.swift
//  Investiro
//
//  Created by Adrian Neshad on 2025-11-08.
//


import SwiftUI
import Foundation

enum Category: String, CaseIterable, Identifiable, Codable {
    case noje = "Nyheter"
    case polisen = "Polisen"
    case myndighet = "Myndigheter"
    case sport = "Sport"
    case finans = "Ekonomi"
    case fotboll = "Fotboll"
    case aktier = "Aktier"
    
    var iconName: String {
        switch self {
        case .noje: return "newspaper"
        case .sport: return "figure.run"
        case .polisen: return "shield.lefthalf.fill"
        case .finans: return "dollarsign.circle"
        case .myndighet: return "building.columns"
        case .fotboll: return "soccerball"
        case .aktier: return "chart.line.uptrend.xyaxis"
        }
    }
    
    var id: String { self.rawValue }

    var sources: [NewsSource] {
        switch self {
        case .polisen:
            if UserDefaults.standard.string(forKey: "appLanguage") == "no" {
                return [
                    NewsSource(name: "Nasjonale nyheter", logo: "norge", url: nil),
                    NewsSource(name: "Agder politidistrikt", logo: "agder", url: nil),
                    NewsSource(name: "Finnmark politidistrikt", logo: "finnmark", url: nil),
                    NewsSource(name: "Innlandet politidistrikt", logo: "innlandet", url: nil),
                    NewsSource(name: "Møre og Romsdal politidistrikt", logo: "more", url: nil),
                    NewsSource(name: "Nordland politidistrikt", logo: "nordland", url: nil),
                    NewsSource(name: "Oslo politidistrikt", logo: "oslo", url: nil),
                    NewsSource(name: "Sør-Vest politidistrikt", logo: "norge", url: nil),
                    NewsSource(name: "Sør-Øst politidistrikt", logo: "norge", url: nil),
                    NewsSource(name: "Troms politidistrikt", logo: "troms", url: nil),
                    NewsSource(name: "Trøndelag politidistrikt", logo: "trondelag", url: nil),
                    NewsSource(name: "Vest politidistrikt", logo: "norge", url: nil),
                    NewsSource(name: "Øst politidistrikt", logo: "norge", url: nil),
                ]
            } else if UserDefaults.standard.string(forKey: "appLanguage") == "fi" {
                return [
                NewsSource(name: "Poliisihallitus", logo: "finland", url: nil),
                NewsSource(name: "Keskusrikospoliisi", logo: "finland", url: nil),
                NewsSource(name: "Helsingin poliisilaitos", logo: "finland", url: nil),
                NewsSource(name: "Hämeen poliisilaitos", logo: "finland", url: nil),
                NewsSource(name: "Itä-Suomen poliisilaitos", logo: "finland", url: nil),
                NewsSource(name: "Itä-Uudenmaan poliisilaitos", logo: "finland", url: nil),
                NewsSource(name: "Kaakkois-Suomen poliisilaitos", logo: "finland", url: nil),
                NewsSource(name: "Lapin poliisilaitos", logo: "finland", url: nil),
                NewsSource(name: "Lounais-Suomen poliisilaitos", logo: "finland", url: nil),
                NewsSource(name: "Länsi-Uudenmaan poliisilaitos", logo: "finland", url: nil),
                NewsSource(name: "Oulun poliisilaitos", logo: "finland", url: nil),
                NewsSource(name: "Pohjanmaan poliisilaitos", logo: "finland", url: nil),
                NewsSource(name: "Sisä-Suomen poliisilaitos", logo: "finland", url: nil),
                
                ]
            } else if UserDefaults.standard.string(forKey: "appLanguage") == "en" {
                return [
                    NewsSource(name: "U.S. Department of Defense", logo: "dod", url: nil),
                    NewsSource(name: "U.S. Courts", logo: "courts", url: nil),
                    NewsSource(name: "Federal Reserve", logo: "fedreserve", url: nil),
                    NewsSource(name: "FBI National Press Releases", logo: "fbi", url: nil),
                    NewsSource(name: "U.S. Department of State", logo: "state", url: nil),
                ]
            }
            
            return [
                // Nationella
                NewsSource(name: "Nyheter", logo: "sverige", url: nil),
                NewsSource(name: "Pressmeddelanden", logo: "sverige", url: nil),

                // Region Nord
                NewsSource(name: "Jämtland - Nyheter", logo: "jämtland", url: nil),
                NewsSource(name: "Jämtland - Händelser", logo: "jämtland", url: nil),
                NewsSource(name: "Västerbotten - Nyheter", logo: "västerbotten", url: nil),
                NewsSource(name: "Västerbotten - Händelser", logo: "västerbotten", url: nil),
                NewsSource(name: "Norrbotten - Nyheter", logo: "norrbotten", url: nil),
                NewsSource(name: "Norrbotten - Händelser", logo: "norrbotten", url: nil),
                NewsSource(name: "Västernorrland - Nyheter", logo: "västernorrland", url: nil),
                NewsSource(name: "Västernorrland - Händelser", logo: "västernorrland", url: nil),
                // Region Mitt
                NewsSource(name: "Gävleborg - Nyheter", logo: "gävleborg", url: nil),
                NewsSource(name: "Gävleborg - Händelser", logo: "gävleborg", url: nil),
                NewsSource(name: "Uppsala - Nyheter", logo: "uppsala", url: nil),
                NewsSource(name: "Uppsala - Händelser", logo: "uppsala", url: nil),
                NewsSource(name: "Västmanland - Nyheter", logo: "västmanland", url: nil),
                NewsSource(name: "Västmanland - Händelser", logo: "västmanland", url: nil),
                // Region Stockholm
                NewsSource(name: "Stockholm - Nyheter", logo: "stockholm", url: nil),
                NewsSource(name: "Stockholm - Händelser", logo: "stockholm", url: nil),
                NewsSource(name: "Gotland - Nyheter", logo: "gotland", url: nil),
                NewsSource(name: "Gotland - Händelser", logo: "gotland", url: nil),
                // Region Öst
                NewsSource(name: "Södermanland - Nyheter", logo: "södermanland", url: nil),
                NewsSource(name: "Södermanland - Händelser", logo: "södermanland", url: nil),
                NewsSource(name: "Östergötland - Nyheter", logo: "östergötland", url: nil),
                NewsSource(name: "Östergötland - Händelser", logo: "östergötland", url: nil),
                NewsSource(name: "Jönköping - Nyheter", logo: "jönköping", url: nil),
                NewsSource(name: "Jönköping - Händelser", logo: "jönköping", url: nil),
                // Region Väst
                NewsSource(name: "Halland - Nyheter", logo: "halland", url: nil),
                NewsSource(name: "Halland - Händelser", logo: "halland", url: nil),
                NewsSource(name: "Västra Götaland - Nyheter", logo: "västragötaland", url: nil),
                NewsSource(name: "Västra Götaland - Händelser", logo: "västragötaland", url: nil),
                // Region Syd
                NewsSource(name: "Skåne - Nyheter", logo: "skåne", url: nil),
                NewsSource(name: "Skåne - Händelser", logo: "skåne", url: nil),
                NewsSource(name: "Blekinge - Nyheter", logo: "blekinge", url: nil),
                NewsSource(name: "Blekinge - Händelser", logo: "blekinge", url: nil),
                NewsSource(name: "Kronoberg - Nyheter", logo: "kronoberg", url: nil),
                NewsSource(name: "Kronoberg - Händelser", logo: "kronoberg", url: nil),
                NewsSource(name: "Kalmar - Nyheter", logo: "kalmar", url: nil),
                NewsSource(name: "Kalmar - Händelser", logo: "kalmar", url: nil),
                // Region Bergslagen
                NewsSource(name: "Värmland - Nyheter", logo: "värmland", url: nil),
                NewsSource(name: "Värmland - Händelser", logo: "värmland", url: nil),
                NewsSource(name: "Örebro - Nyheter", logo: "örebro", url: nil),
                NewsSource(name: "Örebro - Händelser", logo: "örebro", url: nil),
                NewsSource(name: "Dalarna - Nyheter", logo: "dalarna", url: nil),
                NewsSource(name: "Dalarna - Händelser", logo: "dalarna", url: nil),
            ]

        case .noje:
            if UserDefaults.standard.string(forKey: "appLanguage") == "no" {
                return [
                    NewsSource(name: "Verdens Gang", logo: "vg", url: nil),
                    NewsSource(name: "TV2", logo: "tv2", url: nil),
                    NewsSource(name: "NRK", logo: "nrk", url: nil),
                    NewsSource(name: "Dagbladet", logo: "dagbladet", url: nil),
                    NewsSource(name: "Aftenposten", logo: "aftenposten", url: nil),
                    NewsSource(name: "Nettavisen", logo: "nettavisen", url: nil),
                    NewsSource(name: "E24", logo: "e24", url: nil),
                ]
            } else if UserDefaults.standard.string(forKey: "appLanguage") == "fi" {
                return [
                    NewsSource(name: "Helsingin Sanomat", logo: "hs", url: nil),
                    NewsSource(name: "Yle", logo: "yle", url: nil),
                    NewsSource(name: "Iltalehti", logo: "iltalehti", url: nil),
                    NewsSource(name: "Ilta-Sanomat", logo: "is", url: nil),
                ]
            } else if UserDefaults.standard.string(forKey: "appLanguage") == "en" {
                return [
                    NewsSource(name: "NBC News", logo: "nbc", url: nil),
                    NewsSource(name: "ABC News", logo: "abclogo", url: nil),
                    NewsSource(name: "CBS News", logo: "cbs", url: nil),
                    NewsSource(name: "The New York Times", logo: "nytimes", url: nil),
                    NewsSource(name: "Fox News", logo: "fox", url: nil),
                    NewsSource(name: "Wall Street Journal", logo: "wsj", url: nil),
                ]
            }
            
            return [
                NewsSource(name: "Aftonbladet", logo: "aftonbladet_logo", url: nil),
                NewsSource(name: "Expressen", logo: "exp_logo", url: nil),
                NewsSource(name: "Svenska Dagbladet", logo: "svd_logo", url: nil),
                NewsSource(name: "SVT", logo: "svt_logo", url: nil),
                NewsSource(name: "TV4", logo: "tv4_logo", url: nil),
                NewsSource(name: "Dagens Industri", logo: "di_logo", url: nil),
                NewsSource(name: "Dagens Nyheter", logo: "dn_logo", url: nil),
            ]
            
        case .myndighet:
            if UserDefaults.standard.string(forKey: "appLanguage") == "no" {
                return [
                    NewsSource(name: "Norges Bank", logo: "norgesbank", url: nil),
                    NewsSource(name: "Regjeringen", logo: "regjeringen", url: nil),
                    NewsSource(name: "Forskningsrådet", logo: "forskning", url: nil),
                    NewsSource(name: "Skatteetaten", logo: "skatte", url: nil),
                ]
            } else if UserDefaults.standard.string(forKey: "appLanguage") == "fi" {
                return [
                    NewsSource(name: "Eduskunta", logo: "eduskunta", url: nil),
                ]
            } else if UserDefaults.standard.string(forKey: "appLanguage") == "en" {
                return [
                    NewsSource(name: "U.S. Department of Defense", logo: "dod", url: nil),
                    NewsSource(name: "U.S. Courts", logo: "courts", url: nil),
                    NewsSource(name: "Federal Reserve", logo: "fedreserve", url: nil),
                    NewsSource(name: "FBI National Press Releases", logo: "fbi", url: nil),
                    NewsSource(name: "U.S. Department of State", logo: "state", url: nil),
                ]
            }
            
            return [
                NewsSource(name: "Folkhälsomyndigheten", logo: "fhm_logo", url: nil),
                NewsSource(name: "Krisinformation", logo: "ki_logo", url: nil),
                NewsSource(name: "MSB", logo: "msb_logo", url: nil),
                NewsSource(name: "Regeringen", logo: "regeringen_logo", url: nil),
                NewsSource(name: "Skatteverket", logo: "skatteverket_logo", url: nil),
                NewsSource(name: "Livsmedelsverket", logo: "livsmedelsverket_logo", url: nil),
                NewsSource(name: "Läkemedelsverket", logo: "läkemedelsverket_logo", url: nil),
                NewsSource(name: "Riksbanken", logo: "riksbanken_logo", url: nil),
            ]
            
        case .finans:
            if UserDefaults.standard.string(forKey: "appLanguage") == "no" {
                return [
                    NewsSource(name: "Finansavisen", logo: "finansavisen", url: nil),
                    NewsSource(name: "E24 Børs og finans", logo: "e24", url: nil),
                ]
            } else if UserDefaults.standard.string(forKey: "appLanguage") == "fi" {
                return [
                    NewsSource(name: "HS - Talous", logo: "hs", url: nil),
                    NewsSource(name: "Yle - Talous", logo: "yle", url: nil),
                    NewsSource(name: "IS - Taloussanomat", logo: "is", url: nil),
                ]
            } else if UserDefaults.standard.string(forKey: "appLanguage") == "en" {
                return [
                    NewsSource(name: "Financial Times", logo: "ft", url: nil),
                    NewsSource(name: "CBS Moneywatch", logo: "cbs", url: nil),
                    NewsSource(name: "ABC Business", logo: "abclogo", url: nil),
                    NewsSource(name: "Bloomberg", logo: "bloomberg", url: nil),
                ]
            }
            
            return [
                NewsSource(name: "Expressen Ekonomi", logo: "exp_logo", url: nil),
                NewsSource(name: "Placera", logo: "placera", url: nil),
            ]
            
        case .sport:
            if UserDefaults.standard.string(forKey: "appLanguage") == "no" {
                return [
                    NewsSource(name: "NRK Sport", logo: "nrk", url: nil),
                    NewsSource(name: "TV2 Sport", logo: "tv2", url: nil),
                ]
            } else if UserDefaults.standard.string(forKey: "appLanguage") == "fi" {
                return [
                    NewsSource(name: "Yle - Urheilu", logo: "yle", url: nil),
                    NewsSource(name: "HS - Urheilu", logo: "hs", url: nil),
                    NewsSource(name: "IS - Urheilu", logo: "is", url: nil),
                ]
            } else if UserDefaults.standard.string(forKey: "appLanguage") == "en" {
                return [
                    NewsSource(name: "Sky Sports", logo: "sky", url: nil),
                    NewsSource(name: "Fox Sports", logo: "fox", url: nil),
                    NewsSource(name: "CBS Sports", logo: "cbs", url: nil),
                    NewsSource(name: "ESPN", logo: "espn", url: nil),
                ]
            }
            
            return [
                NewsSource(name: "SportExpressen", logo: "exp_logo", url: nil),
                NewsSource(name: "SVT Sport", logo: "svt_logo", url: nil),
            ]
            
        case .fotboll:
            if UserDefaults.standard.string(forKey: "appLanguage") == "fi" {
                return [
                    NewsSource(name: "IS - Jalkapallo", logo: "is", url: nil),
                ]
            } else if UserDefaults.standard.string(forKey: "appLanguage") == "en" {
                return [
                    NewsSource(name: "ESPN Soccer", logo: "espn", url: nil),
                    NewsSource(name: "Fox Sports Soccer", logo: "fox", url: nil),
                ]
            }
            return [
                NewsSource(name: "Fotbollskanalen", logo: "fk_logo", url: nil),
                NewsSource(name: "FotbollsExpressen", logo: "exp_logo", url: nil),
                NewsSource(name: "Fotbolltransfers", logo: "ft_logo", url: nil),
            ]
        
        case .aktier:
            return [
                NewsSource(name: "Nasdaq", logo: "nasdaq", url: nil),
            ]
        }
    }
    
    func localizedName(language: String) -> String {
        switch self {
        case .noje:
            if language == "fi" {
                return "Uutiset"
            } else if language == "no" {
                return "Nyheter"
            } else if language == "en" {
                return "News"
            } else {
                return "Nyheter"
            }
        case .myndighet:
            if language == "fi" {
                return "Viranomaiset"
            } else if language == "no" {
                return "Autoriteter"
            } else if language == "en" {
                return "Authorities"
            } else {
                return "Myndigheter"
            }
        case .finans:
            if language == "fi" {
                return "Talous"
            } else if language == "no" {
                return "Økonomi"
            } else if language == "en" {
                return "Finance"
            } else {
                return "Ekonomi"
            }
        case .polisen:
            if language == "fi" {
                return "Poliisi"
            } else if language == "no" {
                return "Politiet"
            } else if language == "en" {
                return "Authorities"
            } else {
                return "Polisen"
            }
        case .sport:
            if language == "fi" {
                return "Urheilu"
            } else if language == "en" {
                return "Sports"
            } else {
                return "Sport"
            }
        case .fotboll:
            if language == "fi" {
                return "Jalkapallo"
            } else if language == "no" {
                return "Fotball"
            } else if language == "en" {
                return "Soccer"
            } else {
                return "Fotboll"
            }
        case .aktier:
            if language == "fi" {
                return "Osakkeet"
            } else if language == "no" {
                return "Aksjer"
            } else if language == "en" {
                return "Stocks"
            } else {
                return "Aktier"
            }
        }
    }
}
