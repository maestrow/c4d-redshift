IMAGE=c4drs-ubuntu-demo

debug/build:
	docker run --rm -ti --gpus=all \
		-v $(PWD)/distr:/distr \
		-v $(PWD)/models:/models \
		nvidia/cuda:11.1-runtime-ubuntu18.04

debug:
	docker run --rm -ti --gpus=all \
		-v $(PWD)/distr:/distr \
		-v $(PWD)/models:/models \
		$(IMAGE)

render:
	docker run -ti --gpus=all \
		-v $(PWD)/distr:/distr \
		-v $(PWD)/models:/models \
		$(IMAGE) \
		-redshift-gpu 0 -render /models/door/White_Room_Door_3D_Model.c4d -oimage /models/door/result1 -oformat JPG

build: distr/start build/image distr/stop

build/image:
	docker build -t $(IMAGE) .

distr/start:
	docker run -d --rm --name=distrib -p 8080:80 -v $(PWD)/distr:/usr/share/nginx/html:ro nginx

distr/stop:
	docker stop distrib