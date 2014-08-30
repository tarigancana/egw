require 'mongoid'
require 'sinatra'
require 'sinatra/json'
require 'sinatra/reloader' if development?
require 'sinatra/assetpack'
require_relative 'app/models/subject'
require_relative 'app/models/item'

Mongoid.load!('config/mongoid.yml')

assets {
  serve '/fonts', from: 'app/fonts'

  js :app, [
    '/js/jquery.js',
    '/js/bootstrap.js',
    '/js/main.js'
  ]

  css :app, [
    '/fonts/*.*',
    '/css/*.*'
  ]
}

get '/' do
  erb :'subjects/index'
end

get '/search' do
  @subjects = Subject.where(name: /^#{params[:search]}/i)

  erb :'subjects/index'
end

get '/subjects/:query' do
  @subjects = Subject.where(name: /^#{params[:query]}/i)

  erb :'subjects/index'
end

get '/subject/:id' do
  @subject = Subject.find(params[:id])

  erb :'subjects/show'
end

get '/subjects.json' do
  skip = params[:page] * 50

  @subjects = Subject.skip(page).limit(50)

  json @subjects
end
