class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend
  belongs_to :activity
  belongs_to :threshold

  validates :user,
    :friend,
    :activity,
    presence: true

  delegate :summary, to: :activity
  delegate :name, to: :user, prefix: true
  delegate :name, to: :friend, prefix: true

  alias_method :description, :summary

  scope :recent, lambda { |n| limit(n).order('id desc') }

  def to_s
    self.id
  end
end
