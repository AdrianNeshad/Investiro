//
//  RSSFetcher.swift
//  Investiro
//
//  Created by Adrian Neshad on 2025-11-08.
//

import Foundation
import CoreLocation

class RSSFetcher {
    func fetchFeed(from url: URL, source: NewsSource, completion: @escaping (Result<[NewsItem], Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }

            let delegate = RSSParserDelegate(source: source, completion: completion)
            let parser = XMLParser(data: data)
            parser.delegate = delegate
            parser.parse()
        }
        task.resume()
    }
}

private class RSSParserDelegate: NSObject, XMLParserDelegate {
    private let source: NewsSource
    private let completionHandler: (Result<[NewsItem], Error>) -> Void

    private var items: [NewsItem] = []
    private var currentElement = ""
    private var currentTitle = ""
    private var currentDescription = ""
    private var currentPubDateString = ""
    private var currentImageURLString: String?
    private var currentLinkString = ""
    private var currentTickers: [String] = []

    init(source: NewsSource, completion: @escaping (Result<[NewsItem], Error>) -> Void) {
        self.source = source
        self.completionHandler = completion
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if elementName == "item" {
            currentTitle = ""
            currentDescription = ""
            currentPubDateString = ""
            currentImageURLString = nil
            currentLinkString = ""
            currentTickers = []
        }

        if (elementName == "enclosure" || elementName == "media:content"), let url = attributeDict["url"] {
            currentImageURLString = url
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            currentTitle += string
        case "description":
            currentDescription += string
        case "pubDate":
            currentPubDateString += string
        case "link":
            currentLinkString += string
        case "nasdaq:tickers":
            let cleaned = string
                .components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
            currentTickers.append(contentsOf: cleaned)
        default:
            break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            if currentImageURLString == nil {
                currentImageURLString = extractFirstImageURL(from: currentDescription)
            }

            let pubDate = parseDate(from: currentPubDateString)
            let imageURL = currentImageURLString.flatMap(URL.init)
            let linkURL = URL(string: currentLinkString.trimmingCharacters(in: .whitespacesAndNewlines))
            _ = currentTitle + " " + currentDescription

            if let pubDate = pubDate,
               let limitDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()),
               pubDate >= limitDate {

                let newsItem = NewsItem(
                    title: currentTitle.trimmingCharacters(in: .whitespacesAndNewlines).decodedHTML,
                    description: currentDescription.trimmingCharacters(in: .whitespacesAndNewlines).decodedHTML,
                    imageURL: imageURL,
                    source: source,
                    pubDate: pubDate,
                    link: linkURL,
                    tickers: currentTickers
                )

                items.append(newsItem)
            }
        }
    }

    private func parseDate(from string: String) -> Date? {
        let formats = [
            "E, d MMM yyyy HH:mm:ss Z",
            "yyyy-MM-dd'T'HH:mm:ssZ",
            "yyyy-MM-dd'T'HH:mm:ssXXX"
        ]

        for format in formats {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = format
            if let date = formatter.date(from: string.trimmingCharacters(in: .whitespacesAndNewlines)) {
                return date
            }
        }

        return nil
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        completionHandler(.success(items))
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        completionHandler(.failure(parseError))
    }

    private func extractFirstImageURL(from html: String) -> String? {
        guard let imgRange = html.range(of: "<img[^>]*src=[\"']([^\"']+)[\"'][^>]*>", options: .regularExpression) else {
            return nil
        }

        let imgTag = html[imgRange]
        let pattern = "src=[\"']([^\"']+)[\"']"
        if let regex = try? NSRegularExpression(pattern: pattern),
           let match = regex.firstMatch(in: String(imgTag), range: NSRange(imgTag.startIndex..., in: imgTag)),
           let range = Range(match.range(at: 1), in: imgTag) {
            var urlString = String(imgTag[range])
            if urlString.hasPrefix("//") {
                urlString = "https:" + urlString
            } else if urlString.hasPrefix("/") {
                switch source.name {
                case "Svenska Dagbladet":
                    urlString = "https://www.svd.se" + urlString
                case "SVT":
                    urlString = "https://www.svt.se" + urlString
                default:
                    break
                }
            }
            return urlString
        }
        return nil
    }
}
