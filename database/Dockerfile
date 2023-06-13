# Using official Percona MySQL 8.0 image as the base
FROM percona:8.0

# Copy your SQL files to the container
COPY ./sql-scripts/ /docker-entrypoint-initdb.d/

# Expose the default MySQL port
EXPOSE 3306
