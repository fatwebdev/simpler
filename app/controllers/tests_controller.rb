class TestsController < Simpler::Controller

  def index
    @time = Time.now
    # render 'tests/list'
    # render plain: "ola"
    # status 201
    # headers['X-Header'] = 'true'
    @parameters = params
    render inline: "<h1><%= @time %><h1><%= @parameters.inspect %>"
  end

  def create

  end

  def show
    @parameters = params[:id]
  end

end
