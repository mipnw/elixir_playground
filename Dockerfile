FROM alpine as dev
RUN apk update && \
    apk add elixir && \
    apk add bash
ENTRYPOINT ["/bin/bash"]
