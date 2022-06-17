
import Foundation

struct WeatherModel {
    let condition: Int
    let cityName: String
    let temperature: Double
    
    var getTemperature: String {
        return String(format: "%.1f", temperature)
    }
    var getConditionName : String {
        get {
            if self.condition % 200 < 100{
                return "cloud.bolt"
            }else if self.condition % 300 < 100{
                return "cloud.drizzle"
            }else if self.condition % 500 < 100{
                return "cloud.rain"
            }else if self.condition % 600 < 100{
                return "cloud.snow"
            }else if self.condition % 700 < 100{
                return "cloud.fog"
            }else if self.condition % 800 < 100{
                if self.condition % 800 == 0 {
                    return "sun.max"
                }
                return "cloud.bolt"
            }else{
                return "cloud"
            }
            
        }
    }
}


