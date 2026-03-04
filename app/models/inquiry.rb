class Inquiry < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :subject, presence: true
  validates :message, presence: true

  # 默认状态
  after_initialize :set_default_status, if: :new_record?

  scope :unread, -> { where(status: 'unread') }
  scope :read, -> { where(status: 'read') }
  scope :ordered, -> { order(created_at: :desc) }
  
  def unread?
    status == 'unread'
  end

  def read?
    status == 'read'
  end

  private

  def set_default_status
    self.status ||= 'unread'
  end
end
