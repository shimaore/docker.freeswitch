NAME=shimaore/freeswitch

image:
	docker build -t ${NAME} .

image-no-cache:
	docker build --no-cache -t ${NAME} .

tests:
	cd test && for t in ./*.sh; do $$t; done

push: image tests
	docker push ${NAME}
