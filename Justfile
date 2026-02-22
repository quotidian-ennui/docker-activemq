set positional-arguments := true
set dotenv-load := true
set unstable := true
set script-interpreter := ['/usr/bin/env', 'bash']

USER := `whoami`
BASE_TAG := USER / "activemq"

# show recipes
[private]
@help:
    just --list --list-prefix "  "

# Build the activemq docker images
[group("build")]
[script]
build tag="all":
    #
    set -eo pipefail

    docker_build() {
      local tag
      local target="$1"
      local dockerfile="$target/Dockerfile"
      local dockerArgs=()
      tag=$(basename "$target")

      if [[ -n "$ACTIVEMQ_VERSION" ]]; then
        echo -e "\n>>> $target (ENV ACTIVEMQ_VERSION=$ACTIVEMQ_VERSION)"
        dockerArgs+=("--build-arg" "ACTIVEMQ_VERSION=$ACTIVEMQ_VERSION")
      else
        echo -e "\n>>> $target ($(cat  "${dockerfile}" | grep "ARG ACTIVEMQ_VERSION"))"
      fi
      docker build . --no-cache --tag "{{ BASE_TAG }}:$tag" -f "$dockerfile" --load "${dockerArgs[@]}"
    }

    case "$1" in
      all)
        DOCKER_TARGETS=$(find . -name Dockerfile | xargs dirname)
        for target in $DOCKER_TARGETS; do
          docker_build "$target"
        done
        ;;
      *)
        docker_build "$1"
        ;;
    esac

# Run a specific image
[group("build")]
@run tag: (build tag)
    docker run -it --rm -e JDK_JAVA_OPTIONS="-Djetty.host=0.0.0.0" \
          -p127.0.0.1:8161:8161 -p127.0.0.1:61616:61616 \
          -p127.0.0.1:5672:5672 -h activemq.local \
          "{{ BASE_TAG }}:{{ tag }}"


# Delete built images
[group("build")]
@clean:
    docker images --format json | jq -r 'select(.Repository | contains("{{ BASE_TAG }}")) | .ID' | xargs -r docker rmi -f || true

# Delete builder cache etc.
[group("build")]
@purge: clean
    docker image prune -f || true
    docker builder prune -f -a || true

# run updatecli with args e.g. just updatecli diff
[group("release")]
@updatecli *action="diff":
    updatecli "$@"

# Show the change log
[group("release")]
@changelog *args="--unreleased":
    git cliff "$@"

# tag and optionally the tag
[group("release")]
[script]
release tag push="localonly":
  #
  set -eo pipefail

  check_uptodate() {
    remote_hash=$(git ls-remote origin refs/heads/main | cut -f1)
    local_hash=$(git rev-parse "$(git branch --show-current)")
    if [[ "$remote_hash" != "$local_hash" ]]; then
      echo "⚠️ Remote hash differs, are we up to date?"
      exit 1
    fi
  }

  git diff --quiet || (echo "⚠️ git is dirty" && exit 1)
  check_uptodate
  tag="{{ tag }}"
  push="{{ push }}"
  git tag "$tag" -m"release: $tag"
  case "$push" in
    push|github|gh)
      git push --tags
      ;;
    *)
      ;;
  esac
