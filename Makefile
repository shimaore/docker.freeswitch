NAME := $(shell jq -r .name package.json)
TAG := $(shell jq -r .version package.json)

image:
	docker build -t ${NAME}:${TAG} .
	docker tag ${NAME}:${TAG} ${REGISTRY}/${NAME}:${TAG}

tests:
	echo 'Nothing to be done'

manual-tests:
	cd test && for t in ./*.sh; do $$t; done

push: image
	docker push ${REGISTRY}/${NAME}:${TAG}
	docker push ${NAME}:${TAG}
	docker rmi ${REGISTRY}/${NAME}:${TAG}
	docker rmi ${NAME}:${TAG}
