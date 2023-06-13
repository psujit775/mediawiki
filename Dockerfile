FROM php:8.1-apache

ENV MEDIAWIKI_MAJOR_VERSION=1.39
ENV MEDIAWIKI_VERSION=1.39.3

# Install System dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    apache2 \
    libonig-dev \
    libicu-dev \
    && rm -rf /var/lib/apt/lists/*

# Install php extensions
RUN docker-php-ext-install intl mysqli

# Download and extract MediaWiki
RUN curl -fsSL https://releases.wikimedia.org/mediawiki/${MEDIAWIKI_MAJOR_VERSION}/mediawiki-${MEDIAWIKI_VERSION}.tar.gz -o mediawiki.tar.gz\
    && tar -x --strip-components=1 -f mediawiki.tar.gz -C /var/www/html \
    && rm -f mediawiki.tar.gz


RUN chown -R www-data:www-data /var/www/html

COPY startup.sh /usr/local/bin/

EXPOSE 80

CMD ["/usr/local/bin/startup.sh"]
