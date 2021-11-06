class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :result, presence: true,
                     inclusion: [-1, 0, 1]

  validates :user, uniqueness: { scope: %i[votable_id votable_type] }
  validates :votable_type, inclusion: %w[Question Answer]

  def up
    update(result: 1)
  end

  def down
    update(result: -1)
  end

  def reset_vote
    update(result: 0)
  end
end
