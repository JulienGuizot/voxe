class Web::ApplicationController < ApplicationController
  before_filter :set_locale

  # will be reset every deploy
  # caches_action :index

  def index
    if params['src'] == 'welcome-page'
      @options = {}
    else
      redirect_to welcome_path
      return
    end
  end

  def add_subscribers


    client = MailerLite::Client.new(api_key: 'ded4fd9599c38105e7ca2522ab24bd25')

    groupId = 4044519

      

    new_sub = client.create_subscriber(groupId, params[:email], options = {})

    redirect_to welcome_path(success: true)

  end

  AVAILABLE_LANGUAGES = I18n.available_locales.map do |l| l.to_s end
  def set_locale
    if params[:locale].present? and params[:locale].in?(AVAILABLE_LANGUAGES)
      session[:locale] = params[:locale]
    elsif request.user_preferred_languages.present?
      session[:locale] = request.preferred_language_from(AVAILABLE_LANGUAGES)
    end
    I18n.locale = session[:locale] if session[:locale].present?
  end

  private
    def set_election
      @only_published_candidacies = true
      @election = Election.where({namespace: params[:namespace]}).first
      # returns 404 if election does not exist
      return not_found unless @election
    end

end
