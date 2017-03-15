NAME := $(shell jq -r .name package.json)
TAG := $(shell jq -r .version package.json)

image:
	docker build --build-arg=WITH_SOUNDS=false -t ${NAME}:${TAG} .
	docker build --build-arg=WITH_SOUNDS=true  -t ${NAME}:${TAG}-with-sounds .
	docker tag ${NAME}:${TAG} ${REGISTRY}/${NAME}:${TAG}
	docker tag ${NAME}:${TAG}-with-sounds ${REGISTRY}/${NAME}:${TAG}-with-sounds

tests:
	echo 'Nothing to be done'

manual-tests:
	cd test && for t in ./*.sh; do $$t; done

push: image
	docker push ${REGISTRY}/${NAME}:${TAG}
	docker push ${REGISTRY}/${NAME}:${TAG}-with-sounds
	docker push ${NAME}:${TAG}
	docker push ${NAME}:${TAG}-with-sounds
	docker rmi ${REGISTRY}/${NAME}:${TAG}
	docker rmi ${REGISTRY}/${NAME}:${TAG}-with-sounds
	docker rmi ${NAME}:${TAG}
	docker rmi ${NAME}:${TAG}-with-sounds
