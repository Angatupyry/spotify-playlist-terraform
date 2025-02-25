FROM runatlantis/atlantis

EXPOSE 4141

WORKDIR /atlantis

COPY atlantis.yaml /atlantis.yaml

CMD ["server", "--repo-allowlist=github.com/angatupyry/spotify-playlist-terraform"]
