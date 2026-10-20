namespace :festival do
  desc "Self-check your schema, models, and routes"
  task check: :environment do
    require Rails.root.join("lib", "festival_check")

    paths = Rails.application.routes.routes.map { |r| r.path.spec.to_s }
    check = FestivalCheck.new(connection: ActiveRecord::Base.connection, route_paths: paths).run
    puts check.report
  end
end
