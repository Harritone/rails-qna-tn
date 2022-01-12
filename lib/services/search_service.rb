class SearchService
  TYPES = %w[Question Answer User Comment].freeze

  def self.call(query, scope = nil)
    if TYPES.include?(scope)
      scope.constantize.search(query)
    else
      ThinkingSphinx.search(query)
    end
  end
end
