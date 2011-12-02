class Theme
  include Mongoid::Document
  include ActsAsList::Mongoid

  field :position,      type: Integer
  field :name,          type: String
  field :parentThemeId, type: String

  belongs_to :election
  belongs_to :theme, foreign_key: :parentThemeId
  has_many :themes, foreign_key: :parentThemeId, dependent: :destroy, autosave: true
  has_many :propositions, foreign_key: :themeId
  has_many :photos, as: :photoable

  acts_as_list column: :position

  validates_presence_of :name

  accepts_nested_attributes_for :themes, :allow_destroy => true, :reject_if => proc { |obj| obj.blank? }
  

  def self.parents
    Theme.where(parentThemeId: nil)
  end

  def sections
    return [] unless election.present?
    themes.map { |category| category.themes }.flatten
  end

  def serializable_hash options = {}
    options ||= {}
    super({include: :themes}.merge(options))
  end

end
