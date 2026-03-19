FROM public.ecr.aws/amazonlinux/amazonlinux:2023

WORKDIR /app
ARG UID=1000
ARG GID=1000

# Update system packages and install dependencies
RUN yum update -y && \
    yum install -y unixODBC glibc-langpack-en shadow-utils

# Install PostgreSQL ODBC and JDBC Drivers
RUN yum install -y postgresql-odbc && \
    mkdir -p /opt/tableau/tableau_driver/jdbc && \
    curl -L https://jdbc.postgresql.org/download/postgresql-42.7.3.jar -o /opt/tableau/tableau_driver/jdbc/postgresql-jdbc.jar

ENV LANG=en_GB.UTF-8
ENV LANGUAGE=en_GB:en
ENV LC_ALL=en_GB.UTF-8

# The build process should have download the Tableau Bridge RPM to the local
# directory, so we copy it into the image:
COPY tableau-bridge.rpm /tmp/tableau-bridge.rpm
RUN ACCEPT_EULA=y yum install -y /tmp/tableau-bridge.rpm && \
    rm -f /tmp/tableau-bridge.rpm

RUN groupadd -g ${GID} tableau_group && \
    useradd -u ${UID} -g ${GID} -m -s /bin/bash tableau_user && \
    chown -R tableau_user:tableau_group /opt/tableau

USER tableau_user

# Set the standard startup script as the container entrypoint
ENTRYPOINT ["/opt/tableau/tableau_bridge/bin/run-bridge.sh"]
