import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []


        let trenutniDatum = Date()
        for dodaniDani in 0 ..< 7 {
            let entryDatum = Calendar.current.date(byAdding: .day, value: dodaniDani, to: trenutniDatum)!
            let ponoc = Calendar.current.startOfDay(for: entryDatum)
            let entry = SimpleEntry(date: ponoc)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct mkajic20_WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack{
            ContainerRelativeShape().fill(Color(red: 1, green: 0.3, blue: 0.1))
        
            VStack{
                Text(entry.date
                        .formatted(.dateTime.locale(.init(identifier: "hr_HR"))
                        .month(.wide))
                        .capitalized)
                    .font(.title)
                    .fontWeight(.bold)
                    
                Text(entry.date
                        .formatted(.dateTime.day()))
                    .font(.system(size:80, weight: .heavy))
                    .foregroundColor(.white)
                    
                Text(entry.date
                    .formatted(.dateTime.locale(.init(identifier:"hr_HR")).weekday(.wide))
                    .capitalized)
            }
        }
    }
}

struct mkajic20_Widget: Widget {
    let kind: String = "mkajic20_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            mkajic20_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Moj widget")
        .description("Ovaj widget pokazuje trenutni datum i dan u tjednu.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct mkajic20_Widget_Previews: PreviewProvider {
    static var previews: some View {
        mkajic20_WidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
