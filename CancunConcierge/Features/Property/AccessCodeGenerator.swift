//
//  AccessCodeGenerator.swift
//  CancunConcierge
//
//  Created by usuario on 29/10/26.
//

import Foundation
import Security

enum AccessCodeGenerator {

    static func generate() throws -> String {

        let characters = Array("ABCDEFGHJKLMNPQRSTUVWXYZ23456789")
        var code = ""

        for _ in 0..<10 {

            var randomByte: UInt8 = 0

            let result = SecRandomCopyBytes(
                kSecRandomDefault,
                1,
                &randomByte
            )

            guard result == errSecSuccess else {
                throw NSError(
                    domain: "AccessCodeGenerator",
                    code: Int(result),
                    userInfo: [
                        NSLocalizedDescriptionKey:
                            "Unable to generate a secure access code."
                    ]
                )
            }

            // Evitamos sesgos al convertir números aleatorios
            // en posiciones del arreglo.
            guard randomByte < 224 else {
                // Reintentaremos esta posición.
                var validByte: UInt8 = 0

                repeat {
                    let retryResult = SecRandomCopyBytes(
                        kSecRandomDefault,
                        1,
                        &validByte
                    )

                    guard retryResult == errSecSuccess else {
                        throw NSError(
                            domain: "AccessCodeGenerator",
                            code: Int(retryResult)
                        )
                    }

                } while validByte >= 224

                code.append(characters[Int(validByte) % characters.count])
                continue
            }

            code.append(characters[Int(randomByte) % characters.count])
        }

        return "CN-\(code)"
    }
}
