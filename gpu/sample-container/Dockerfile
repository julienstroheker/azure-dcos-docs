FROM gcr.io/tensorflow/tensorflow:latest-gpu

COPY ./ /app
ADD entry.sh /app/
RUN chmod +x /app/entry.sh

EXPOSE 80

ENTRYPOINT ["/app/entry.sh"]