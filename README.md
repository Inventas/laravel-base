# laravel-base

This repository builds the shared Laravel runtime image:

```text
ghcr.io/inventas/laravel-base:latest
```

## Runtime

- PHP 8.5.9
- Server Side Up `fpm-nginx` on Alpine Linux
- AMD64 and ARM64 support
- Composer, Node.js, npm, MariaDB client, AWS CLI, libvips, and the required PHP extensions

The Dockerfile uses `serversideup/php:8.5.9-fpm-nginx-alpine` and pins its multi-platform OCI index digest. Update the tag, digest, and PHP version check together when you update PHP.

## Build

Use OrbStack and Buildx to test each target architecture:

```shell
docker buildx build --platform linux/amd64 --output=type=cacheonly .
docker buildx build --platform linux/arm64 --output=type=cacheonly .
```
