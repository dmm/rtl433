FROM debian:trixie AS build

ENV MQTT_HOST=localhost MQTT_PORT=1883 MQTT_USER= MQTT_PASS= BASE_TOPIC=RTL_433 USE_CHANNEL=no LISTEN_FREQUENCY=433M

RUN echo "deb-src http://deb.debian.org/debian stable main" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y build-essential git \
    && apt-get build-dep -y rtl-433

RUN git clone https://github.com/merbanan/rtl_433.git   && cd rtl_433/   && mkdir build   && cd build   && cmake ../   && make   && make install


FROM debian:trixie

# Install rtl_433 deps
RUN apt-get update && apt-get install -y libc6 librtlsdr0 libsoapysdr0.7 libusb-1.0-0

COPY --from=build /usr/local/bin/rtl_433 /usr/local/bin/rtl_433

CMD ["/bin/sh", "-c", "rtl_433 -M newmodel -M utc -f $LISTEN_FREQUENCY -F \"$MQTT_CONNECTION_STRING\""]
