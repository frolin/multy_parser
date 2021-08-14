# == Route Map
#

Rails.application.routes.draw do
  get 'parsers/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
# Most off apps would require
# 	telegram_webhook TelegramController, :multi_parser
end
