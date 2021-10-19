Blazer::QueriesController.class_eval do
  private

  def set_queries(limit = nil)
    # With the exception of this first statement which scopes the query to the current_user's
    # organization, all of this code is identical to the :set_queries method from the
    # Blazer 2.4.7 source code.
    @queries = Blazer::Query.named
      .joins(creator: :organization)
      .where(creator: {organization: current_organization})
      .select(:id, :name, :creator_id, :statement)
    @queries = @queries.includes(:creator) if Blazer.user_class

    if blazer_user && params[:filter] == "mine"
      @queries = @queries.where(creator_id: blazer_user.id).reorder(updated_at: :desc)
    elsif blazer_user && params[:filter] == "viewed" && Blazer.audit
      @queries = queries_by_ids(Blazer::Audit.where(user_id: blazer_user.id).order(created_at: :desc).limit(500).pluck(:query_id).uniq)
    else
      @queries = @queries.limit(limit) if limit
      @queries = @queries.active.order(:name)
    end
    @queries = @queries.to_a

    @more = limit && @queries.size >= limit

    @queries = @queries.select { |q| !q.name.to_s.start_with?("#") || q.try(:creator).try(:id) == blazer_user.try(:id) }

    @queries =
      @queries.map do |q|
        {
          id: q.id,
          name: q.name,
          creator: blazer_user && q.try(:creator) == blazer_user ? "You" : q.try(:creator).try(Blazer.user_name),
          vars: q.variables.join(", "),
          to_param: q.to_param
        }
      end
  end
end