NAME=shimaore/freeswitch
TAG=`jq -r .version package.json`

image:
	docker build --rm=true -t ${NAME}:${TAG} .

tests:
	cd test && for t in ./*.sh; do $$t; done

push: image
	docker push ${NAME}:${TAG}
