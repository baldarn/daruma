# frozen_string_literal: true

class Resolution < ApplicationRecord
  validates :body, presence: true, length: { maximum: 150 }
  validates :commitment, presence: true
  validates :time_limit, presence: true
  validates :temper, presence: true
  validates :offer, allow_blank: true, numericality: { only_numeric: true, greater_than_or_equal_to: 0 }

  enum :commitment, %i[low moderate high], prefix: true
  enum :temper, %i[motivational sarcastic authoritarian random], prefix: true

  belongs_to :user
  has_many :reminders, dependent: :destroy

  def generate_reminder
    reminder = Reminder.create(body: reminder_text, resolution: self)
    reminder.remind
  end

  def reminder_text
    return 'reminder text' if Rails.env.test? || Rails.env.development?

    client = OpenAI::Client.new

    response = client.chat(
      parameters: {
        model: 'gpt-3.5-turbo',
        messages: [{ role: 'user', content: prompt.squish }]
      }
    )
    response.dig('choices', 0, 'message', 'content').gsub('```', '')
  end

  def prompt
    ret = "write a #{temper_for_request} sentence to motivate me using at most
    50 words in #{user.language} for my proposition."

    if reminders.count.positive?
      ret += "must be different from these previous sentences, enclosed in double backticks:
        #{reminders.last(5).map { |r| "``#{r.body}``" }.join(' ')}"
    end

    ret += "The proposition is delimited with triple backticks ```#{body}```"
    ret
  end

  def temper_for_request
    return Resolution.tempers.excluding('random').keys.sample if temper_random?

    temper
  end
end
