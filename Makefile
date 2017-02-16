NAME := $(shell jq -r .name package.json)
MODE := $(shell jq -r .mode package.json)
TAG := $(shell jq -r .version package.json)

image:
	docker build -t ${NAME}:${TAG}${MODE} .
	docker tag ${NAME}:${TAG}${MODE} ${REGISTRY}/${NAME}:${TAG}${MODE}

tests:
	echo 'Nothing to be done'

manual-tests:
	cd test && for t in ./*.sh; do $$t; done

push: image
	docker push ${REGISTRY}/${NAME}:${TAG}${MODE}
	docker push ${NAME}:${TAG}${MODE}
	docker rmi ${REGISTRY}/${NAME}:${TAG}${MODE}
	docker rmi ${NAME}:${TAG}${MODE}
