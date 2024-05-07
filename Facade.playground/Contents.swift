import Foundation

// MARK: - Facade Design Pattern
/// *Structural*
/// - Simplifies complexity of an interface to add convinience
/// - Decouples the client side from the complex API
/// - Only exposes what's needed
/// - Protects consumers from frequent changes on components (beta APIs)

// MARK: - Pitfalls
/// - Keep it simple to not break SRP
/// - Do not leak details of the underlying type

// MARK: - Implementation

import NaturalLanguage

public class NLPFacade {
    private static let tagger = NLTagger(tagSchemes: [NLTagScheme.lexicalClass])

    public struct WordLexicalClassPair: CustomStringConvertible {
        let word: String
        let lexical: String

        public var description: String {
            "\(word): \(lexical)"
        }
    }

    public class func dominantLang(for string: String) -> String? {
        let lang = NLLanguageRecognizer.dominantLanguage(for: string)
        return lang?.rawValue
    }

    public class func partsOfSpech(for text: String) -> [WordLexicalClassPair] {
        var result = [WordLexicalClassPair]()
        tagger.string = text
        tagger.enumerateTags(
            in: text.startIndex..<text.endIndex,
            unit: .word,
            scheme: .lexicalClass,
            options: [.omitPunctuation, .omitWhitespace]
        ) { tag, range in
            let wordLexicalClass = WordLexicalClassPair.init(
                word: String(text[range]),
                lexical: (tag?.rawValue ?? "unknown")
            )
            result.append(wordLexicalClass)
            return true
        }
        return result
    }
}

let text = "The facade is simple yet useful"
print(text)

let language = NLPFacade.dominantLang(for: text)
print(language)

let result = NLPFacade.partsOfSpech(for: text)
print(result)
