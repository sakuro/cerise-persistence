# frozen_string_literal: true

RSpec.describe Cerise::Persistence::Repository do
  describe "inherited" do
    let(:app_name) { "App" }
    let(:inflector) { Dry::Inflector.new }

    before do
      allow(Hanami).to receive_message_chain(:app, :app_name, :namespace_name).and_return(app_name)
      allow(Hanami).to receive_message_chain(:app, :[]).with("inflector").and_return(inflector)
      stub_const("#{app_name}::Entities", Module.new)
    end

    it "sets struct_namespace" do
      repo_class = Class.new(Cerise::Persistence::Repository)

      expect(repo_class.struct_namespace).to eq(App::Entities)
    end
  end
end
