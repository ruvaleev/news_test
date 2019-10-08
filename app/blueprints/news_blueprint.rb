class NewsBlueprint < Blueprinter::Base
  identifier :id

  fields :title, :created_at

  view :extended do
    field :text
  end
end
