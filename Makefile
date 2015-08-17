release:
	docker build -t atlassianlabs/fluentd:$(tag) .
	docker push atlassianlabs/fluentd:$(tag)
