# laravel-base

This repository builds Alpine and Debian variants of the shared Laravel runtime image.

The default image stays on Alpine for compatibility with existing projects:

```text
ghcr.io/inventas/laravel-base:latest
```

## Image tags

| Operating system | Moving tag | PHP patch tag |
| --- | --- | --- |
| Alpine Linux | `alpine`, `latest` | `8.5.9-alpine` |
| Debian | `debian` | `8.5.9-debian` |

## Runtime

- PHP 8.5.9
- Node.js 24
- Server Side Up `fpm-nginx` on Alpine Linux or Debian
- AMD64 and ARM64 support
- Composer, Node.js, npm, MariaDB client, AWS CLI, libvips, and the required PHP extensions

`Dockerfile` uses the Alpine image. `Dockerfile.debian` uses the Debian image and copies Node.js from a pinned official Node image. All upstream images use pinned multi-platform OCI index digests. Update each tag, digest, PHP version check, and published patch tag together when you update PHP.

## Build

Use OrbStack and Buildx to test each target architecture:

```shell
docker buildx build --platform linux/amd64 --output=type=cacheonly -f Dockerfile .
docker buildx build --platform linux/arm64 --output=type=cacheonly -f Dockerfile .
docker buildx build --platform linux/amd64 --output=type=cacheonly -f Dockerfile.debian .
docker buildx build --platform linux/arm64 --output=type=cacheonly -f Dockerfile.debian .
```
