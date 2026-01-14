# syntax=docker/dockerfile:1
# check=error=true

ARG RUBY_VERSION=3.4.5
FROM ruby:${RUBY_VERSION}-alpine AS base

WORKDIR /rails

# Install base packages for Alpine:
# tzdata: needed for TZInfo
# jemalloc: memory optimization
# gcompat: shim for glibc binaries (needed for precompiled gems/binaries)
# libpq: PostgreSQL runtime library
RUN apk add --no-cache \
    gcompat \
    jemalloc \
    libpq \
    tzdata

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development" \
    # Improve performance with jemalloc and YJIT \
    LD_PRELOAD="/usr/lib/libjemalloc.so.2" \
    MALLOC_CONF="dirty_decay_ms:1000,narenas:2,background_thread:true" \
    RUBY_YJIT_ENABLE="1"

FROM base AS build

# Install packages needed to build gems
RUN apk add --no-cache \
    build-base \
    git \
    pkgconf \
    postgresql-dev \
    yaml-dev

# Install application gems with rigorous cleanup
COPY Gemfile Gemfile.lock ./
RUN --mount=type=cache,target=/usr/local/bundle/cache \
    bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile && \
    # Remove unneeded files (test files, C source files, leftovers)
    rm -rf "${BUNDLE_PATH}"/ruby/*/gems/*/test && \
    rm -rf "${BUNDLE_PATH}"/ruby/*/gems/*/spec && \
    rm -rf "${BUNDLE_PATH}"/ruby/*/extensions/*/*/*.c && \
    rm -rf "${BUNDLE_PATH}"/ruby/*/extensions/*/*/*.o

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile && \
    # Cleanup compiled assets source (optional, but saves space)
    rm -rf node_modules

# Final stage for app image
FROM base

# Copy built artifacts: gems, application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Create a non-root user
RUN addgroup -S -g 1000 rails && \
    adduser -S -u 1000 -G rails -s /bin/sh rails && \
    chown -R rails:rails db log storage tmp

USER 1000:1000

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start server via Thruster by default, this can be overwritten at runtime
EXPOSE 80
CMD ["./bin/thrust", "bundle", "exec", "puma", "-C", "config/puma.rb"]
