NAME=shimaore/`jq -r .name[7:] package.json`
TAG=`jq -r .version package.json`

image:
	docker build --rm=true -t ${NAME}:${TAG} .

tests:
	cd test && for t in ./*.sh; do $$t; done

push: image
	docker tag -f ${NAME}:${TAG} ${REGISTRY}/${NAME}:${TAG}
	docker push ${REGISTRY}/${NAME}:${TAG}
	docker push ${NAME}:${TAG}
