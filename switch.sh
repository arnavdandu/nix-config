#!/usr/bin/env bash
set -e

case "$(uname)" in
  Darwin)
    exec sudo darwin-rebuild switch --flake .#Arnavs-MacBook-Pro "$@"
    ;;
  Linux)
    exec sudo nixos-rebuild switch --flake .#arnav-nix "$@"
    ;;
  *)
    echo "Unknown OS: $(uname)" >&2
    exit 1
    ;;
esac
