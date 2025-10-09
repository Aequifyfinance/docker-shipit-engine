Rails.application.configure do
    # Existing production config...
    # Disable force SSL for public IP testing
    config.force_ssl = false
    config.middleware.delete ActionDispatch::SSL
end