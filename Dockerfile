FROM debian:trixie

ENV MQTT_HOST=localhost MQTT_PORT=1883 MQTT_USER= MQTT_PASS= BASE_TOPIC=RTL_433 USE_CHANNEL=no LISTEN_FREQUENCY=433M

RUN apt-get update \
    && apt-get install -y rtl-433 \
    # clean up
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \ # /wheels \
    && (apt-get autoremove -y; apt-get autoclean -y)

CMD ["/bin/sh", "-c", "rtl_433 -M newmodel -M utc -f $LISTEN_FREQUENCY -F \"$MQTT_CONNECTION_STRING\""]
