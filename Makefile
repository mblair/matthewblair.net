docker:
	docker build -t web:$$(git rev-parse --short HEAD) .

run:
	docker run web:$$(git rev-parse --short HEAD)
