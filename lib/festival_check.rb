# Structural self-check for the Festival Schema Sprint.
# Run with:  bin/rails festival:check
#
# This checks that the pieces exist and are wired together. It does not
# check that your choices are well reasoned; the reflection answers do that.
class FestivalCheck
  Result = Struct.new(:section, :ok, :message)

  TABLES = {
    "festivals"    => %w[name starts_on city],
    "stages"       => %w[name capacity festival_id],
    "artists"      => %w[name genre],
    "tracks"       => %w[title length_sec artist_id],
    "attendees"    => %w[name email],
    "tickets"      => %w[tier price_cents attendee_id festival_id],
    "performances" => %w[starts_at stage_id artist_id]
  }.freeze

  # [child table, parent table]
  FOREIGN_KEYS = [
    %w[stages festivals],
    %w[tracks artists],
    %w[tickets attendees],
    %w[tickets festivals],
    %w[performances stages],
    %w[performances artists]
  ].freeze

  BELONGS_TO = [
    ["Stage", :festival], ["Track", :artist],
    ["Ticket", :attendee], ["Ticket", :festival],
    ["Performance", :stage], ["Performance", :artist]
  ].freeze

  HAS_MANY = [
    ["Festival", :stages], ["Artist", :tracks],
    ["Attendee", :tickets], ["Festival", :tickets],
    ["Stage", :performances], ["Artist", :performances]
  ].freeze

  HAS_MANY_THROUGH = [
    ["Stage", :artists, :performances],
    ["Artist", :stages, :performances]
  ].freeze

  MODELS = %w[Festival Stage Artist Track Attendee Ticket Performance].freeze

  ROUTES = {
    "Stages nested under festivals"        => "/festivals/:festival_id/stages(.:format)",
    "Tracks nested under artists"          => "/artists/:artist_id/tracks(.:format)",
    "Tickets nested under attendees"       => "/attendees/:attendee_id/tickets(.:format)",
    "Tickets nested under festivals"       => "/festivals/:festival_id/tickets(.:format)",
    "Performances nested under stages"     => "/stages/:stage_id/performances(.:format)",
    "Performances nested under artists"    => "/artists/:artist_id/performances(.:format)"
  }.freeze

  # connection: an ActiveRecord connection
  # route_paths: array of route path strings, e.g. "/festivals/:festival_id/stages(.:format)"
  def initialize(connection:, route_paths:)
    @connection = connection
    @route_paths = route_paths
    @results = []
  end

  attr_reader :results

  def run
    check_schema
    check_models
    check_routes
    self
  end

  def passed
    @results.count(&:ok)
  end

  def total
    @results.size
  end

  def report
    lines = []
    @results.group_by(&:section).each do |section, rs|
      lines << ""
      lines << section.upcase
      rs.each { |r| lines << "  #{r.ok ? '[ok]  ' : '[FIX] '} #{r.message}" }
    end
    lines << ""
    lines << "#{passed} of #{total} checks passing."
    lines << "Structure only: the reflection answers cover your reasoning."
    lines.join("\n")
  end

  private

  def add(section, ok, message)
    @results << Result.new(section, ok ? true : false, message)
  end

  def check_schema
    TABLES.each do |table, columns|
      if @connection.table_exists?(table)
        have = @connection.columns(table).map(&:name)
        missing = columns - have
        add("Schema", missing.empty?,
            missing.empty? ? "#{table}: table and columns present" : "#{table}: missing column(s) #{missing.join(', ')}")
      else
        add("Schema", false, "#{table}: table not found (did you run bin/rails db:migrate?)")
      end
    end

    FOREIGN_KEYS.each do |child, parent|
      has = @connection.table_exists?(child) &&
            @connection.foreign_keys(child).any? { |fk| fk.to_table == parent }
      add("Schema", has, "#{child} has a foreign key to #{parent}")
    end
  end

  # Returns the model class, or nil if it is missing or fails to load.
  # Load errors are remembered so the report can show the real message.
  def model(name)
    @load_errors ||= {}
    Object.const_get(name)
  rescue NameError, StandardError, ScriptError => e
    @load_errors[name] = "#{e.class}: #{e.message.lines.first.to_s.strip}"
    nil
  end

  def check_models
    MODELS.each do |name|
      klass = model(name)
      if klass.nil?
        why = @load_errors && @load_errors[name]
        add("Models", false, "#{name}: model not found or failed to load (app/models/#{name.downcase}.rb)#{why ? " -> #{why}" : ''}")
      else
        add("Models", klass.validators.any?, "#{name} has at least one validation")
      end
    end

    BELONGS_TO.each do |name, assoc|
      refl = model(name)&.reflect_on_association(assoc)
      add("Models", refl && refl.macro == :belongs_to, "#{name} belongs_to :#{assoc}")
    end

    HAS_MANY.each do |name, assoc|
      refl = model(name)&.reflect_on_association(assoc)
      add("Models", refl && refl.macro == :has_many, "#{name} has_many :#{assoc}")
      next unless name == "Festival" || name == "Artist" || name == "Attendee" || name == "Stage"
      next if assoc == :performances # dependent: on join records is a stretch decision
      add("Models", refl && refl.options[:dependent], "#{name} has_many :#{assoc} declares dependent:")
    end

    HAS_MANY_THROUGH.each do |name, assoc, through|
      refl = model(name)&.reflect_on_association(assoc)
      add("Models", refl && refl.macro == :has_many && refl.options[:through] == through,
          "#{name} has_many :#{assoc}, through: :#{through}")
    end
  end

  def check_routes
    ROUTES.each do |label, path|
      add("Routes", @route_paths.include?(path), label)
    end

    shallow = @route_paths.include?("/tracks/:id(.:format)") &&
              !@route_paths.include?("/artists/:artist_id/tracks/:id(.:format)")
    add("Routes", shallow, "Tracks use shallow nesting (/tracks/:id, not /artists/:artist_id/tracks/:id)")
  end
end
