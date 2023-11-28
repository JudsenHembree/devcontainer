IMAGE_NAME=jhembre/devcontainer
IMAGE_TAG=latest

all:
	docker build . -t $(IMAGE_NAME):$(IMAGE_TAG)

run:
	docker run -it --rm -v $(PWD):/work -w /work $(IMAGE_NAME):$(IMAGE_TAG) bash

push:
	docker push $(IMAGE_NAME):$(IMAGE_TAG)
