FROM ruby:3.0-bullseye

# Install required system packages
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      git \
      curl \
      gnupg \
      nodejs \
      postgresql-client \
      tzdata \
      yarnpkg \
      shared-mime-info \
      build-essential \
      libpq-dev \
      libsqlite3-dev \
      libxml2-dev \
      libxslt1-dev && \
    rm -rf /var/lib/apt/lists/*

ENV CI=true
ENV SHIPIT_VERSION=v0.39.0

# Configure Git identity (for rails new template)
RUN git config --global user.email "saksham@aequify.com"
RUN git config --global user.name "Saksham Saini"

# Install Ruby gems
RUN gem install rails -v 7.1.5 --no-document
RUN gem install minitest --no-document

WORKDIR /usr/src

# Generate the Shipit Rails app
RUN ruby -r logger -S rails _7.1.5_ new shipit \
  --database=postgresql \
  --skip-action-cable \
  --skip-turbolinks \
  --skip-action-mailer \
  --skip-active-storage \
  -m https://raw.githubusercontent.com/Shopify/shipit-engine/${SHIPIT_VERSION}/template.rb

WORKDIR /usr/src/shipit

# Add PostgreSQL gem explicitly (template may skip it)
RUN echo 'gem "pg", "~> 1.5"' >> Gemfile

# Install bundle dependencies
RUN cd shipit && sed -i '/sqlite3/d' Gemfile && echo 'gem "pg", "~> 1.5"' >> Gemfile
RUN bundle install --jobs 4

# Copy app configs
COPY config/ config/

# Set Rails production environment variables
ENV RAILS_ENV=production \
    RAILS_LOG_TO_STDOUT=enabled \
    RAILS_SERVE_STATIC_FILES=enabled

# Add entrypoint
COPY entrypoint.sh .
ENTRYPOINT ["./entrypoint.sh"]

# Precompile assets
RUN bundle exec rake assets:precompile

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
