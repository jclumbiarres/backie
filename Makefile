.PHONY: run build squirrel

run:
	gleam run

build:
	gleam build

squirrel:
	@DATABASE_URL=$$(grep ^DATABASE_URL .env | cut -d '=' -f2 | tr -d '"') gleam run -m squirrel