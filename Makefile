NAME=shimaore/freeswitch
TAG=`jq -r .version package.json`

image:
	docker build -t ${NAME} .
	docker tag ${NAME}:${TAG} ${NAME}:latest

tests:
	cd test && for t in ./*.sh; do $$t; done

push: image tests
	docker push ${NAME}:${TAG}
	docker push ${NAME}:latest
