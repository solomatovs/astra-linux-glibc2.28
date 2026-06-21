# astra-linux

Сборка базового Docker-образа на основе Astra Linux (Orel) с пересобранной из исходников **glibc 2.28** и русской локалью `ru_RU.UTF-8`. Нужен, чтобы запускать на Astra бинарники, требующие более новый glibc, чем в штатном образе.

## Команды

| Команда | Что делает |
|---------|------------|
| `make help` | список команд (по умолчанию) |
| `make sources` | скачать исходники glibc в `artifacts/glibc-src/`; напоминает положить tar базового образа astra в `artifacts/` |
| `make build` | собрать образ `astra-linux:<ASTRA_VERSION>-glibc<GLIBC_VERSION>` (цель `glibc` из `Dockerfile`) |

## Переменные

`ASTRA_VERSION` (2.12), `GLIBC_VERSION` (2.28), `ARTIFACTS` (`artifacts`), `IMAGE`, `BUILD_CONTEXT` — переопределяются при вызове, напр.:

```sh
make build GLIBC_VERSION=2.31
```
