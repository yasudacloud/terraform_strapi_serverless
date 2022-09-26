FROM amazon/aws-lambda-nodejs:16
RUN yum install hostname -y
CMD [ "index.handler" ]
COPY ./ /var/task
VOLUME ["/mnt/efs"]
WORKDIR "/var/task"
EXPOSE 2049
