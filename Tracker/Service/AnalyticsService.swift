import Foundation
import AppMetricaCore

struct AnalyticsService {
    static func activate() {
        guard let configuration = AppMetricaConfiguration(apiKey: "bfedc414-cdc6-4744-a221-bd32b3731203") else { return }
        AppMetrica.activate(with: configuration)
    }

    func report(event: String, params: [AnyHashable : Any]) {
        print("📊 Отправка события: \(event), параметры: \(params)")
        
        AppMetrica.reportEvent(name: event, parameters: params, onFailure: { error in
            print("❌ REPORT ERROR: \(error.localizedDescription)") // ← Исправлено
        })
    }
}

