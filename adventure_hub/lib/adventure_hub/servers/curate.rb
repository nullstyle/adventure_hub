module AdventureHub
  module Servers
    class Curate < Servers::Base

      get "/" do

      end

      # get a page of resources
      get "/resources/next" do

      end

      # write a rating
      put "/resources/:id/rating" do |id|

      end

      

    end
  end
end
