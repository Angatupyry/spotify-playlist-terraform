terraform {
  required_providers {
    spotify = {
      version = "~> 0.2.6"
      source  = "conradludgate/spotify"
    }
  }
}

provider "spotify" {
  api_key = var.spotify_api_key
  api_url = "http://spotify-auth-proxy:27228"
}

data "spotify_search_track" "by_artist" {
  artist = "Dolly Parton"
  #  album = "Jolene"
  #  name  = "Early Morning Breeze"
}

data "spotify_search_track" "rock_song" {
  artist = "Queen"
  name   = "Bohemian Rhapsody"
}

data "spotify_search_track" "pop_song" {
  artist = "Taylor Swift"
  name   = "Shake It Off"
}

resource "spotify_playlist" "playlist" {
  name        = "My Custom Terraform Playlist"
  description = "This playlist was created by Terraform"
  public      = true

  tracks = [
    data.spotify_search_track.by_artist.tracks[0].id,
    data.spotify_search_track.by_artist.tracks[1].id,
    data.spotify_search_track.by_artist.tracks[2].id,
    data.spotify_search_track.by_artist.tracks[3].id,
    data.spotify_search_track.by_artist.tracks[4].id,
    data.spotify_search_track.rock_song.tracks[0].id,
    data.spotify_search_track.pop_song.tracks[0].id
  ]
}