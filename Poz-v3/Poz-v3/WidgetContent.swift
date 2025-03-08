import WidgetKit

struct WidgetContent: TimelineEntry {
  var date = Date()
  let name: String
  let cardViewSubtitle: String
  let descriptionPlainText: String
  let releasedAtDateTimeString: String
}
