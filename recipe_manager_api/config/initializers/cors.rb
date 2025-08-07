# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin Ajax requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins [
      'https://recipe-manager-eight-indol.vercel.app',
      'https://recipe-manager-git-main-aline-taylors-projects.vercel.app', 
      'https://recipe-manager-bhmbp26xl-aline-taylors-projects.vercel.app',
      'http://localhost:4200'
    ]

    resource "*",
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
