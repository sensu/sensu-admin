module ClientsHelper
  def format_subscriptions(subscriptions)
    return "N/A" if subscriptions.blank? || subscriptions.nil?
    subs = subscriptions.join(",")
    subs.length > 50 ? "#{subs[0..50]}..." : subs
  end
end
