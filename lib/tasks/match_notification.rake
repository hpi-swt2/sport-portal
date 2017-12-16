namespace :match_notification do
  desc 'Sends emails to all match participants 24 hours in advance. This task should only be run once an hour. Otherwise multiple emails for the same event are send.'
  task send_match_notification: :environment do
    matches = Match.joins(:event).where(events: { startdate: Date.tomorrow })
    matches.find_each(batch_size: 10) do |match|
      match.event.participants.find_each(batch_size: 10) do |participant|
        MatchMailer.match_notification(participant, match).deliever_now
      end
    end
  end
end
